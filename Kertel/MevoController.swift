//
//  MevoController.swift
//  Kertel
//
//  Created by Kertel on 22/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class MevoController: UITableViewController, APIControllerProtocol {

    var refresher: UIRefreshControl!
    var mevoDataTableView: [Mevo] = []
    var deleteAllButton : UIBarButtonItem!
    var apiController : APIController? //set by loginViewController
    var getMevoDelegate : GetMevoDelegate!
    var delMevoDelegate : DelMevoDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MevoController -> viewDidLoad")
        
        //refresh mevo
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        // bouton tout effacer mevo
        deleteAllButton = UIBarButtonItem(title : "Effacer", style: .plain, target: self, action: #selector(deleteAllButton(sender :)))
        
        // bouton edit
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //set delegate
        getMevoDelegate = GetMevoDelegate(mevoDelegate: self)
        delMevoDelegate = DelMevoDelegate(mevoDelegate: self)
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //navigationItem.title = "Messagerie (5/30)"
        print("MevoController -> viewDidAppear")
    }
    
    
    func refresh()
    {
        apiController?.getMevo(delegate: getMevoDelegate)
    }
    
    //return of GET getMevo
    class GetMevoDelegate : APIDelegate
    {
        var mevoDelegate : MevoController
        
        init (mevoDelegate : MevoController!)
        {
            self.mevoDelegate = mevoDelegate
        }

        func success(data: [AnyObject]?) {
            DispatchQueue.main.async {
            self.mevoDelegate.mevoDataTableView.removeAll()
            self.mevoDelegate.mevoDataTableView = data as! [Mevo]
            self.mevoDelegate.tableView.reloadData()
            self.mevoDelegate.refresher.endRefreshing()
            }
            print("APIController.getMevo() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.getMevo() fail")
            self.mevoDelegate.refresher.endRefreshing()
        }
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
        let deleteAction = UIAlertAction(title:"Effacer tous les messages", style: .destructive, handler: {
            action in
            
            var mevoToDelete : [String] = []
            for mevo in self.mevoDataTableView
            {
                mevoToDelete.append(mevo.id)
            }
            self.apiController?.delMevo(delegate: self.delMevoDelegate, idMevoToDelete: mevoToDelete)
            
            self.mevoDataTableView.removeAll()
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
   
    //return of DEL delMevo
    class DelMevoDelegate : APIDelegate
    {
        var mevoDelegate : MevoController
        
        init (mevoDelegate : MevoController!)
        {
            self.mevoDelegate = mevoDelegate
        }
        
        func success(data: [AnyObject]?) {
            print("APIController.delMevo() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.delMevo() fail")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mevoDataTableView.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        /*if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerMevoCell", for: indexPath)
            tableView.estimatedRowHeight = 140
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "mevoCell", for: indexPath)
            //tableView.estimatedRowHeight = 58
        }*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "mevoCell", for: indexPath) as! MevoTableViewCell
        cell.mevo = mevoDataTableView[indexPath.row]

        return cell
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    // remove table item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteOneMevo(id : mevoDataTableView[indexPath.row].id, indexPath: indexPath)
        }
    }

    func deleteOneMevo(id : String, indexPath: IndexPath)
    {
        apiController?.delMevo(delegate: delMevoDelegate, idMevoToDelete: [id])
        
        mevoDataTableView.remove(at:indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoMevoController = segue.destination as? InfoMevoController
        {
            if let index = self.tableView.indexPathForSelectedRow{
                infoMevoController.mevo = mevoDataTableView[index.row]
                infoMevoController.apiController = self.apiController
                infoMevoController.indexPath = index
            }
        }
    }

}
