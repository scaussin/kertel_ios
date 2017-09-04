//
//  InfoMevoController.swift
//  Kertel
//
//  Created by Kertel on 11/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit
import AVFoundation

class InfoMevoController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol, AVAudioPlayerDelegate {

    var mevo : Mevo? //set by MevoController
    
    @IBOutlet weak var progressBar: UIProgressView!
    var mevoAudio: AVAudioPlayer!
    var timer : Timer?
    var apiController : APIController? //set by MevoController
    var speakerMode = false
    var indexPath: IndexPath?
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var speakerButton: UIImageView!
    
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoMevoController -> viewDidLoad")
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("AVAudioSession error: \(error.localizedDescription)")
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        print("InfoMevoController -> viewDidAppear")
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        stopMevo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButton(_ sender: Any)
    {
        if let sound =  mevoAudio, sound.isPlaying  //stop
        {
            stopMevo()
            progressBar.setProgress(0, animated: false)
        }
        else //play
        {
            checkMevoFileAndDoAction(successAction: playMevoAction)
        }
    }
    
    func checkMevoFileAndDoAction(successAction : @escaping (URL) -> ())
    {
        let urlMevo = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent((mevo?.id)!.appending(".wav"))
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: urlMevo.relativePath)) {
            print("file exist")
            successAction(urlMevo)
        } else {
            print("file doesn't exist")
            apiController?.getMevoData(delegate: MevoDataDelegate(urlMevo: urlMevo, successAction: successAction), idMevo: (mevo?.id)!)
        }
    }

    @IBAction func speakerButton(_ sender: Any) {
        print("speaker button")
        do {
            if (self.speakerMode) { //to quit speaker
                if (mevoAudio.isPlaying)
                {
                    setProximitySensor(true)
                }
                speakerButton.backgroundColor = UIColor.clear
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            }
            else{ //to speaker
                setProximitySensor(false)
                speakerButton.backgroundColor = UIColor.lightGray
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            self.speakerMode = !self.speakerMode
        }
        catch let error as NSError  {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    class MevoDataDelegate : APIDelegateRawData
    {
        //var infoMevoDelegate : InfoMevoController
        var urlMevo : URL
        var successAction : (URL) -> ()
        
        init (urlMevo : URL, successAction : @escaping (URL) -> ())
        {
            self.urlMevo = urlMevo
            self.successAction = successAction
        }
        
        func success(data: Data?) {
            print("APIController.getMevoData() success")
            do {
                try data?.write(to: urlMevo)
            }
            catch (let error){
                print("Failed to create file: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.successAction(self.urlMevo)
            }
        }
        
        func fail(msgError : String)
        {
            print("APIController.getMevoData() fail")
        }
    }

    func playMevoAction(urlMevo : URL)
    {
        progressBar.setProgress(0, animated: false)
        playImage.image = UIImage(named: "stop")
        do {
            mevoAudio = try AVAudioPlayer(contentsOf: urlMevo)
            mevoAudio.delegate = self
            if (!speakerMode)
            {
                setProximitySensor(true)
            }
            mevoAudio.play()
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
        } catch let error as NSError  {
            stopMevo()
            print("audioSession playMevo error: \(error.localizedDescription)")
        }
    }
    
    func shareMevoAction(urlMevo : URL)
    {
        let objectsToShare = [urlMevo]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func setProximitySensor(_ enabled: Bool) {
        let device = UIDevice.current
        if (enabled != device.isProximityMonitoringEnabled)
        {
            device.isProximityMonitoringEnabled = enabled
            if device.isProximityMonitoringEnabled {
                NotificationCenter.default.addObserver(self, selector: #selector(proximityChanged), name: .UIDeviceProximityStateDidChange, object: device)
            } else {
                NotificationCenter.default.removeObserver(self, name: .UIDeviceProximityStateDidChange, object: nil)
            }
        }
    }
    
    func proximityChanged(_ notification: Notification) {
        if let device = notification.object as? UIDevice {
            if (device.proximityState == false && mevoAudio?.isPlaying == false) //far and not playing
            {
                setProximitySensor(false)
            }
        }
    }
    
    @objc func updateProgressBar()
    {
        if mevoAudio.isPlaying
        {
            progressBar.setProgress(Float(mevoAudio.currentTime / mevoAudio.duration), animated: false)
        }
    }
    
    func stopMevo()
    {
        print("stop")
        timer?.invalidate()
        mevoAudio?.stop()
        playImage.image = UIImage(named: "play")
        setProximitySensor(false)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopMevo()
        progressBar.setProgress(1, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subviews = cell.subviews
        if subviews.count >= 3 {
            for subview in subviews {
                if subview != cell.contentView {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = nil
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
            let titleDataTVC = cell as! TitleDataTableViewCell
            //titleDataTVC.selectionStyle = .none
            titleDataTVC.titleLabel.text = "Date"
            titleDataTVC.dataLabel.text = mevo?.getDate()
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataClickableCell", for: indexPath) as! TitleDataClickableTableViewCell
            let titleDataTVC = cell as! TitleDataClickableTableViewCell
            titleDataTVC.titleLabel.text = "Numéro"
            titleDataTVC.dataLabel.text = mevo?.getNumber()
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
            let titleDataTVC = cell as! TitleDataTableViewCell
            //titleDataTVC.selectionStyle = .none
            titleDataTVC.titleLabel.text = "Durée"
            titleDataTVC.dataLabel.text = mevo?.getDuration()
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
            let titleDataTVC = cell as! TitleClickableTableViewCell
            //titleDataTVC.selectionStyle = .none
            titleDataTVC.titleLabel.text = "Partager ce message"
            titleDataTVC.titleLabel.textColor = greenKertel
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
            let titleDataTVC = cell as! TitleClickableTableViewCell
            //titleDataTVC.selectionStyle = .none
            titleDataTVC.titleLabel.text = "Supprimer ce message"
            titleDataTVC.titleLabel.textColor = redKertel
        default:
            let empty = UITableViewCell()
            empty.selectionStyle = .none
            return empty
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 1) //call
        {
            if let phoneCallURL = URL(string: "tel://\(mevo?.number ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        else if (indexPath.row == 3) //share
        {
            checkMevoFileAndDoAction(successAction: shareMevoAction)
        }
        else if (indexPath.row == 5) //delete
        {
            let alertController = UIAlertController( title: nil,
                                                     message: nil,
                                                     preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title:"Effacer ce message", style: .destructive, handler: {
                action in
                let mevoController = self.parent?.childViewControllers[0] as! MevoController
                mevoController.deleteOneMevo(id: (self.mevo?.id)!, indexPath: self.indexPath!)
                self.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title:"Annuler", style: .cancel, handler: {
                action in
            })
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            //apiController?.delMevo(delegate: DelMevoDelegate(), idMevoToDelete: [(mevo?.id)!])
            
        }
    }
    
    /*class DelMevoDelegate : APIDelegate
    {
        init ()
        {
            
        }
        
        func success(data: [AnyObject]?) {
            print("APIController.delMevo() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.delMevo() fail")
        }
    }*/

}
