//
//  CallHistoryController.swift
//  Kertel
//
//  Created by Kertel on 24/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class CallHistoryController: UITableViewController, APIDelegate{

    var refresher: UIRefreshControl!
    var apiController : APIController?
    var deleteAllButton : UIBarButtonItem!
    var CallHistoryDataTableView: [CallHistory] = []
    /*var dataTest: [CallHistory] = [
                                    
                                    CallHistory(callId: "", name: "André Sanfraper", number: "0634543244", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true),
                                    CallHistory(callId: "", name: "Jacques Célère",number: "0634543255", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true),
                                    CallHistory(callId: "", name: "Brice Denisse", number: "0634543266", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true),
                                    CallHistory(callId: "", name: "Sacha Touille", number: "0634543277", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true),
                                    CallHistory(callId: "", name: "Yves Rogne", number: "0634543288", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true),
                                    CallHistory(callId: "", name: "Alain Terrieur", number: "0634543299", state: "", duration: TimeInterval(), date: Date(), isIncoming: true, isSeen: true)]*/
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CallHistoryController -> viewDidLoad")

        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        deleteAllButton = UIBarButtonItem(title : "Effacer", style: .plain, target: self, action: #selector(deleteAllButton(sender :)))
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if (editing) {
            super.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem = self.deleteAllButton
        } else {
            super.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func deleteAllButton(sender : UIBarButtonItem)
    {
        let alertController = UIAlertController( title: nil,
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title:"Effacer tous les appels", style: .destructive, handler: {
            action in
            self.CallHistoryDataTableView.removeAll()
            self.tableView.reloadData()
            self.setEditing(false, animated: true)
            print("delete all")
        })
        let cancelAction = UIAlertAction(title:"Annuler", style: .cancel, handler: {
            action in
            print("Cancel pressed")
        })
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func refresh()
    {
        apiController?.getIncomingCall(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CallHistoryController -> viewDidAppear")
    }

   
    func success(data: [AnyObject]) {
        DispatchQueue.main.async {
            self.CallHistoryDataTableView.removeAll()
            self.CallHistoryDataTableView += data as! [CallHistory]
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
        print("APIController.getIncomingCall() success")
    }

    func fail(msgError : String)
    {
        print("APIController.getIncomingCall() fail")
        self.refresher.endRefreshing()
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
        return CallHistoryDataTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallHistoryCell", for: indexPath) as! CallHistoryTableViewCell

        cell.callHistory = CallHistoryDataTableView[indexPath.row]
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
            CallHistoryDataTableView.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


}
