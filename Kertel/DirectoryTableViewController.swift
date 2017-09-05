//
//  DirectoryTableViewController.swift
//  Kertel
//
//  Created by Kertel on 22/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController {
    
    var apiController : APIController? //set by DirectoryPageViewController (DirectoryController.swift)
    var isUserContact : Bool! //set by DirectoryPageViewController (DirectoryController.swift)
    var directoryController : DirectoryController! //set by DirectoryPageViewController (DirectoryController.swift)
    var contactDataTableView : [Contact] = []
    var allContactDataTableView : [Contact] = [] //this array is not impacted by search
    var getContactDelegate : GetContactDelegate!
    var delContactDelegate : DelContactDelegate!
    var searchContactCompanyDelegate : SearchContactCompanyDelegate!
    var refresher: UIRefreshControl!
    var search : String! = ""
   // var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getContactDelegate = GetContactDelegate(directoryTVC: self)
        delContactDelegate = DelContactDelegate()
        searchContactCompanyDelegate = SearchContactCompanyDelegate(directoryTVC: self)
        refresh()
    }
    
    func refresh()
    {
        if (isUserContact)
        {
            apiController?.getContactUser(delegate: getContactDelegate)
        }
        else
        {
            if search.characters.count > 0 {
                search(search : search)
            }
            else {
                apiController?.getContactCompany(delegate: getContactDelegate)
            }
        }
    }
    
    func search(search : String!) {
        self.search = search
        if search.characters.count > 0 {
            if (isUserContact) {
                contactDataTableView = allContactDataTableView.filter({ (contact) -> Bool in
                    if contact.sortName.lowercased().range(of: search) != nil {
                        return true
                    }
                    else {
                        return false
                    }
                })
                tableView.reloadData()
            }
            else //search for contactCompany
            {
                apiController?.PostContactCompany(delegate: searchContactCompanyDelegate, search: search)
            }
        }
        else { //empty search
            contactDataTableView = allContactDataTableView
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isUserContact {
            directoryController.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            directoryController.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDataTableView.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "directoryCell", for: indexPath) as! ContactDirectoryTableViewCell

        cell.textLabel?.text = contactDataTableView[indexPath.row].getName()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoContactDirectoryVC = storyboard?.instantiateViewController(withIdentifier: "infoContactDirectoryVC") as! InfoContactDirectoryController
        infoContactDirectoryVC.apiController = apiController
        infoContactDirectoryVC.contact = contactDataTableView[indexPath.row]
        infoContactDirectoryVC.indexPath = indexPath
        infoContactDirectoryVC.parentDirectoryTVC = self
        navigationController?.pushViewController(infoContactDirectoryVC, animated: true)
    }
    
    func deleteOneContact(id : String, indexPath: IndexPath)
    {
        apiController?.delContact(delegate: delContactDelegate, idContactToDelete: id)
        contactDataTableView.remove(at:indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    class DelContactDelegate : APIDelegate
    {
        func success(data: [AnyObject]?) {
            print("APIController.delContact() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.delContact() fail")
        }
    }

    class SearchContactCompanyDelegate : APIDelegate
    {
        var directoryTVC : DirectoryTableViewController
        
        init (directoryTVC : DirectoryTableViewController!)
        {
            self.directoryTVC = directoryTVC
        }
        
        func success(data: [AnyObject]?) {
            DispatchQueue.main.async {
                self.directoryTVC.contactDataTableView.removeAll()
                self.directoryTVC.contactDataTableView = data as! [Contact]
                self.directoryTVC.sortAlphaContact()
                self.directoryTVC.tableView.reloadData()
                self.directoryTVC.refresher.endRefreshing()
            }
            print("APIController.SearchContactCompanyDelegate() success")
        }
        
        func fail(msgError : String)
        {
            print("APIController.SearchContactCompanyDelegate() fail")
            self.directoryTVC.refresher.endRefreshing()
        }
    }
    
    class GetContactDelegate : APIDelegate
    {
        var directoryTVC : DirectoryTableViewController
        
        init (directoryTVC : DirectoryTableViewController!)
        {
            self.directoryTVC = directoryTVC
        }
        
        func success(data: [AnyObject]?) {
            DispatchQueue.main.async {
                self.directoryTVC.allContactDataTableView.removeAll()
                self.directoryTVC.allContactDataTableView = data as! [Contact]
                self.directoryTVC.contactDataTableView.removeAll()
                self.directoryTVC.contactDataTableView = data as! [Contact]
                self.directoryTVC.sortAlphaContact()
                if self.directoryTVC.search.characters.count > 0 {
                    self.directoryTVC.search(search : self.directoryTVC.search)
                }
                self.directoryTVC.tableView.reloadData()
                self.directoryTVC.refresher.endRefreshing()
            }
            if (self.directoryTVC.isUserContact)
            {
                print("APIController.getContactUser() success")
            }
            else
            {
                print("APIController.getContactCompany() success")
            }
        }
        
        func fail(msgError : String)
        {
            if (self.directoryTVC.isUserContact)
            {
                print("APIController.getContactUser() fail")
            }
            else
            {
                print("APIController.getContactCompany() fail")
            }
            self.directoryTVC.refresher.endRefreshing()
        }
    }
    
    func sortAlphaContact()
    {
        contactDataTableView.sort(){$0.sortName < $1.sortName}
        allContactDataTableView.sort(){$0.sortName < $1.sortName}
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
