//
//  InfoMevoController.swift
//  Kertel
//
//  Created by Kertel on 11/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class InfoMevoController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var call : CallHistory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoMevoController -> viewDidAppear")
        //self.nameLabel.text = call?.getPresentationName()
    }

    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 43
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailMevoCell", for: indexPath) as! InfoMevoTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
