//
//  ProfileVC.swift
//  Kertel
//
//  Created by Kertel on 01/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol  {

    var apiController : APIController? //set by SettingEmbedPVC (in SettingVC.swift)
    var user : User?
    var getUserDelegate : GetUserDelegate!
    var loginViewController : LoginViewController?
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProfileVC -> viewDidLoad")
        
        //refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = ""
        getUserDelegate = GetUserDelegate(profileVC: self)
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user == nil{
            return 1
        }
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = nil
        
        if user == nil { //display disconnect button only
            let titleClickableTVC = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
            titleClickableTVC.titleLabel.text = "Se déconnecter"
            titleClickableTVC.titleLabel.textColor = redKertel
            cell = titleClickableTVC as UITableViewCell
        }
        else {
            switch indexPath.row {
            case 0:
                let titleDataTVCTVC = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
                titleDataTVCTVC.titleLabel.text = "Mail"
                titleDataTVCTVC.dataLabel.text = user?.mail
                cell = titleDataTVCTVC as UITableViewCell
            case 1:
                let titleDataTVCTVC = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
                titleDataTVCTVC.titleLabel.text = "Téléphone"
                titleDataTVCTVC.dataLabel.text = user?.telephone
                cell = titleDataTVCTVC as UITableViewCell
            case 2:
                let titleDataTVCTVC = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
                titleDataTVCTVC.titleLabel.text = "Mobile"
                titleDataTVCTVC.dataLabel.text = user?.mobile
                cell = titleDataTVCTVC as UITableViewCell
            case 3:
                let titleDataTVCTVC = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
                titleDataTVCTVC.titleLabel.text = "Numéro court"
                titleDataTVCTVC.dataLabel.text = user?.shortNumber
                cell = titleDataTVCTVC as UITableViewCell
            case 4:
                let titleDataTVCTVC = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
                titleDataTVCTVC.titleLabel.text = "Fax"
                titleDataTVCTVC.dataLabel.text = user?.fax
                cell = titleDataTVCTVC as UITableViewCell
            case 6:
                let titleClickableTVC = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
                titleClickableTVC.titleLabel.text = "Se déconnecter"
                titleClickableTVC.titleLabel.textColor = redKertel
                cell = titleClickableTVC as UITableViewCell
            default:
                let empty = UITableViewCell()
                empty.selectionStyle = .none
                cell = empty
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (tableView.cellForRow(at: indexPath) as? TitleClickableTableViewCell) != nil {
            print("#### disconnect ####")
            apiController!.token = nil
            loginViewController?.autoConnect = false
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
       
    func refresh() {
        apiController?.getUser(delegate: getUserDelegate)
    }
    
    class GetUserDelegate : APIDelegate
    {
        var profileVC : ProfileVC
        
        init (profileVC : ProfileVC!)
        {
            self.profileVC = profileVC
        }
        
        func success(data: [AnyObject]?) {
            print("APIController.getUser() success")
             DispatchQueue.main.async {
                let users = data as! [User]
                self.profileVC.user = users[0]
                self.profileVC.nameLabel.text = users[0].getName()
                self.profileVC.tableView.reloadData()
                self.profileVC.refresher.endRefreshing()
            }
        }
        
        func fail(msgError : String)
        {
            print("APIController.getUser() fail")
            self.profileVC.refresher.endRefreshing()
        }
    }

}
