//
//  CallHistoryController.swift
//  Kertel
//
//  Created by Kertel on 24/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class CallHistoryController: UITableViewController{

    var dataTest: [CallHistory] = [
                                    CallHistory(callId: "", name: "", number: "", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "André Sanfraper", number: "0634543244", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "Jacques Célère",number: "0634543255", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "Brice Denisse", number: "0634543266", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "Sacha Touille", number: "0634543277", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "Yves Rogne", number: "0634543288", state: "", duration: DateInterval(), date: Date(), isIncoming: true),
                                    CallHistory(callId: "", name: "Alain Terrieur", number: "0634543299", state: "", duration: DateInterval(), date: Date(), isIncoming: true)]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.rightBarButtonItem = editButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTest.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallHistoryCell", for: indexPath) as! CallHistoryTableViewCell

        cell.callHistory = dataTest[indexPath.row]
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfoCallSegue" {
          
            let vc = segue.destination as! InfoCallViewController
            
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! CallHistoryTableViewCell
                vc.call = cell.callHistory
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataTest.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


}
