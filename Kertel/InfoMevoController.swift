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
    
    @IBOutlet weak var playImage: UIImageView!
   
    
    @IBOutlet weak var speakerButton: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoMevoController -> viewDidLoad")
    }

    override func viewDidAppear(_ animated: Bool) {
        
        print("InfoMevoController -> viewDidAppear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        stopMevo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButton(_ sender: Any)
    {
        //stop
        if let sound =  mevoAudio, sound.isPlaying
        {
            stopMevo()
            progressBar.setProgress(0, animated: false)
        }
        //play
        else
        {
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent((mevo?.id)!.appending(".wav"))
            let fileManager = FileManager.default
            if (fileManager.fileExists(atPath: path.relativePath)) {
                print("exist")
                playMevo(path: path)
            } else {
                print("doesn't exist")
                apiController?.getMevoData(delegate: MevoDataDelegate(infoMevoDelegate: self), idMevo: (mevo?.id)!)
            }
        }
    }


    @IBAction func speakerButton(_ sender: Any) {
        print("speaker button")
       // AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        //speakerButton.hihli
        var audioSession = AVAudioSession.sharedInstance()
        //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        do {
            //try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
           try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        //mevoAudio?categ.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
    }
    
    class MevoDataDelegate : APIDelegateRawData
    {
        var infoMevoDelegate : InfoMevoController
        
        init (infoMevoDelegate : InfoMevoController!)
        {
            self.infoMevoDelegate = infoMevoDelegate
        }
        
        func success(data: Data?) {
            print("APIController.getMevoData() success")
            
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent((infoMevoDelegate.mevo?.id)!.appending(".wav"))
            
            // Write File
            do {
                try data?.write(to: path)
            }
            catch (let error){
                print("Failed to create file: \(error)")
                return
            }
            
            DispatchQueue.main.async {
               self.infoMevoDelegate.playMevo(path: path)
            }
        }
        
        func fail(msgError : String)
        {
            print("APIController.getMevoData() fail")
            //self.mevoDelegate.refresher.endRefreshing()
        }
    }
    
    
    func playMevo(path : URL)
    {
        progressBar.setProgress(0, animated: false)
        playImage.image = UIImage(named: "stop")
        do {
            mevoAudio = try AVAudioPlayer(contentsOf: path)
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //AVAudioSessionCategoryRecord
            //AVAudioSessionCategoryPlayback
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.init(rawValue: 0)!)
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient,with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            mevoAudio.delegate = self
            mevoAudio.play()
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
            print("playing")
        } catch let error as NSError  {
            stopMevo()
            print("audioSession error: \(error.localizedDescription)")
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
        /*var cell : InfoCallTableViewCell?
        
        if (indexPath.row == 1) // button call number
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCellNumber", for: indexPath) as? InfoCallTableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? InfoCallTableViewCell
        }
        cell?.info = call.infoCall[indexPath.row]*/
        //let cell = tableView.dequeueReusableCell(withIdentifier: "detailMevoCell", for: indexPath) as! InfoMevoTableViewCell
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 1){
            
            if let phoneCallURL = URL(string: "tel://\(mevo?.number ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        /*let indexPath = tableView.indexPathForSelectedRow
        
        f (indexPath?.row == 1){
            
            if let phoneCallURL = URL(string: "tel://\(call.number ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }*/
    }


}

/*class InfoMevoTableViewController: UITableViewController {
    
    var call : CallHistory!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return call.infoCall.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : InfoCallTableViewCell?
        
        if (indexPath.row == 1) // button call number
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCellNumber", for: indexPath) as? InfoCallTableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? InfoCallTableViewCell
        }
        cell?.info = call.infoCall[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if (indexPath?.row == 1){
            
            if let phoneCallURL = URL(string: "tel://\(call.number ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
}*/
