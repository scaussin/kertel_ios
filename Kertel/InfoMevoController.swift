//
//  InfoMevoController.swift
//  Kertel
//
//  Created by Kertel on 11/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit
import AVFoundation

class InfoMevoController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {

    var mevo : Mevo? //set by MevoController
    
    var MevoAudio: AVAudioPlayer!
    var apiController : APIController? //set by MevoController
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoMevoController -> viewDidLoad")
    }

    override func viewDidAppear(_ animated: Bool) {
        
        print("InfoMevoController -> viewDidAppear")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        print("play")
        let mevoData = MevoDataDelegate(infoMevoDelegate: self)
        apiController?.getMevoData(delegate: mevoData, idMevo: (mevo?.id)!)
        
        
        /*let path = tmpDir.stringByAppendingPathComponent(fileName)
        let contentsOfFile = "Sample Text"
        var error: NSError?
        
        // Write File
        if contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error) == false {
            if let errorMessage = error {
                println("Failed to create file")
                println("\(errorMessage)")
            }
        } else {
            println("File sample.txt created at tmp directory")
        }*/
        
       /* let path = Bundle.main.path(forResource: "example.png", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            MevoAudio = sound
            sound.play()
        } catch {
            print("play fail")
        }*/
    }
    
    class MevoDataDelegate : APIDelegateRawData
    {
        var infoMevoDelegate : InfoMevoController
        
        init (infoMevoDelegate : InfoMevoController!)
        {
            self.infoMevoDelegate = infoMevoDelegate
        }
        
        func success(data: NSData?) {
            DispatchQueue.main.async {
                print("ok DownloadMevoDelegate")
                //self.mevoDelegate.mevoDataTableView = data as! [Mevo]
            }
            print("APIController.getMevoData() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.getMevoData() fail")
            //self.mevoDelegate.refresher.endRefreshing()
        }
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
