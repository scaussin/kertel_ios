//
//  CallHistoryController.swift
//  Kertel
//
//  Created by Kertel on 24/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit
import Foundation

class CallHistoryController: UITableViewController , APIControllerProtocol{

    var refresher: UIRefreshControl!
    var apiController : APIController? //set by loginViewController
    var deleteAllButton : UIBarButtonItem!
    var callHistoryDataTableView: [CallHistory] = []
    var incomingDelegate : IncomingDelegate!
    var outgoingDelegate : OutgoingDelegate!
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CallHistoryController -> viewDidLoad")
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        deleteAllButton = UIBarButtonItem(title : "Effacer", style: .plain, target: self, action: #selector(deleteAllButton(sender :)))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        incomingDelegate = IncomingDelegate(callHistoryDelegate: self)
        outgoingDelegate = OutgoingDelegate(callHistoryDelegate: self)
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CallHistoryController -> viewDidAppear")
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
            
            var incomingCallToDelete : [String] = []
            var outgoingCallToDelete : [String] = []
            
            for  call in self.callHistoryDataTableView
            {
                if call.isIncoming
                {
                    incomingCallToDelete.append(call.callId)
                }
                else
                {
                    outgoingCallToDelete.append(call.callId)
                }
            }
            
            if (incomingCallToDelete.count > 0)
            {
                self.apiController?.delIncomingCall(delegate: delHistoryCallDelegate(), idCallsToDelete: incomingCallToDelete)
            }
            if (outgoingCallToDelete.count > 0)
            {
                self.apiController?.delOutgoingCall(delegate: delHistoryCallDelegate(), idCallsToDelete: outgoingCallToDelete)
            }
            self.callHistoryDataTableView.removeAll()
            self.tableView.reloadData()
            self.setEditing(false, animated: true)
        })
        let cancelAction = UIAlertAction(title:"Annuler", style: .cancel, handler: {
            action in
        })
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func refresh()
    {
        apiController?.getIncomingCall(delegate: incomingDelegate)
        apiController?.getOutgoingCall(delegate: outgoingDelegate)
    }
    
    func sortCallHistory()
    {
        callHistoryDataTableView.sort() {$0.date.compare($1.date) == .orderedDescending}
    }
    
    // incoming delegate API
    class IncomingDelegate :APIDelegate
    {
        var callHistoryDelegate : CallHistoryController
        
        init (callHistoryDelegate : CallHistoryController!)
        {
            self.callHistoryDelegate = callHistoryDelegate
        }
        
        func success(data: [AnyObject]?) {
            
            DispatchQueue.main.async {
                self.callHistoryDelegate.callHistoryDataTableView = (self.callHistoryDelegate.callHistoryDataTableView.filter() { $0.isIncoming == false})
                self.callHistoryDelegate.callHistoryDataTableView += data as! [CallHistory]
                self.callHistoryDelegate.sortCallHistory()
                self.callHistoryDelegate.tableView.reloadData()
                self.callHistoryDelegate.refresher.endRefreshing()
            }
            print("APIController.getIncomingCall() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.getIncomingCall() fail")
            self.callHistoryDelegate.refresher.endRefreshing()
        }
    }
   
    // outgoing delegate API
    class OutgoingDelegate :APIDelegate
    {
        var callHistoryDelegate : CallHistoryController
        
        init (callHistoryDelegate : CallHistoryController!)
        {
            self.callHistoryDelegate = callHistoryDelegate
        }
        
        func success(data: [AnyObject]?) {
            
            DispatchQueue.main.async {
                self.callHistoryDelegate.callHistoryDataTableView = (self.callHistoryDelegate.callHistoryDataTableView.filter() { $0.isIncoming == true})
                self.callHistoryDelegate.callHistoryDataTableView += data as! [CallHistory]
                self.callHistoryDelegate.sortCallHistory()
                self.callHistoryDelegate.tableView.reloadData()
                self.callHistoryDelegate.refresher.endRefreshing()
            }
            print("APIController.getOutgoingCall() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.getOutgoingCall() fail")
            self.callHistoryDelegate.refresher.endRefreshing()
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callHistoryDataTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallHistoryCell", for: indexPath) as! CallHistoryTableViewCell

        cell.call = callHistoryDataTableView[indexPath.row]
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfoCallSegue" {
          
            let vc = segue.destination as! InfoCallViewController
            
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! CallHistoryTableViewCell
                vc.call = cell.call
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    class delHistoryCallDelegate : APIDelegate
    {
        
        func success(data: [AnyObject]?) {
            print("history call deleted")
        }
        
        func fail(msgError : String)
        {
            print("APIController.delIncomingCall() fail")
        }
    }
    
    // remove table item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if (callHistoryDataTableView[indexPath.row].isIncoming)
            {
                apiController?.delIncomingCall(delegate: delHistoryCallDelegate(), idCallsToDelete: [callHistoryDataTableView[indexPath.row].callId])
            }
            else
            {
                apiController?.delOutgoingCall(delegate: delHistoryCallDelegate(), idCallsToDelete: [callHistoryDataTableView[indexPath.row].callId])
            }
            
            callHistoryDataTableView.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
