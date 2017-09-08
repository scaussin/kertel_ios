//
//  SettingCallVC.swift
//  Kertel
//
//  Created by Kertel on 04/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

enum TypeTransfert {
    case Incoming
    case Close
    case Busy
}

class SettingCallTVC: UITableViewController, APIControllerProtocol{

    var apiController : APIController? //set by SettingEmbedPVC (in SettingVC.swift)
    //var refresher: UIRefreshControl!
    @IBOutlet weak var busyChoiceLabel: UILabel!
    @IBOutlet weak var closeChoiceLabel: UILabel!
    @IBOutlet weak var incomingChoiceLabel: UILabel!
    var getForwardDelegate : GetForwardDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        busyChoiceLabel.text = ""
        closeChoiceLabel.text = ""
        incomingChoiceLabel.text = ""
        
        //refresh
        /*refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        view.addSubview(refresher)*/
        
        getForwardDelegate = GetForwardDelegate(settingCallTVC: self)
        
        refresh()
    }

    func refresh(){
        
        apiController?.getForward(delegate: getForwardDelegate)
        //refresher.endRefreshing()
        print("refresh")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    class GetForwardDelegate : APIDelegate
    {
        var settingCallTVC : SettingCallTVC
        
        init (settingCallTVC : SettingCallTVC!)
        {
            self.settingCallTVC = settingCallTVC
        }
        
        func success(data: [AnyObject]?) {
            print("APIController.getForward() success")
            /*DispatchQueue.main.async {
                let users = data as! [User]
                self.profileVC.user = users[0]
                self.profileVC.nameLabel.text = users[0].getName()
                self.profileVC.tableView.reloadData()
                self.profileVC.refresher.endRefreshing()
            }*/
        }
        
        func fail(msgError : String)
        {
            print("APIController.getForward() fail")
            //self.profileVC.refresher.endRefreshing()
        }
    }

    func updateChoice(typeTransfert : TypeTransfert, selectedChoice : TypeChoice, numberCustom : String? = nil){
        var labelToUpdate : UILabel?
        
        switch typeTransfert {
        case .Incoming:
            labelToUpdate = incomingChoiceLabel
        case .Close:
            labelToUpdate = closeChoiceLabel
        case .Busy:
            labelToUpdate = busyChoiceLabel
        }
        switch selectedChoice {
        case .CustomNumber:
            labelToUpdate?.text = numberCustom //do formate number
        default:
            labelToUpdate?.text = choiceTable[selectedChoice]?[0]
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transfertChoiceTVC = segue.destination as! TransfertChoiceTVC
        
        transfertChoiceTVC.settingCallTVC = self
        switch segue.identifier! {
        case "toIncomingChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Incoming
            transfertChoiceTVC.selectedChoice = TypeChoice.Phone //TODO
        case "toCloseChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Close
            transfertChoiceTVC.selectedChoice = TypeChoice.CustomNumber //TODO
        case "toBusyChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Busy
            transfertChoiceTVC.selectedChoice = TypeChoice.Mevo //TODO
        default:
            break
        }
    }

}
