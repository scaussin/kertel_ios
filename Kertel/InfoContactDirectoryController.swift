//
//  InfoContactDirectoryController.swift
//  Kertel
//
//  Created by Kertel on 23/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class InfoContactDirectoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {

    var apiController : APIController? //set by DirectoryTableViewController
    var contact : Contact!
    
    @IBOutlet weak var nameLabel: UILabel! // title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = contact.getName()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.infoToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = nil

        if contact.infoToDisplay[indexPath.row].action == .NoAction{
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
            let titleDataTVC = cell as! TitleDataTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.dataLabel.text = contact.infoToDisplay[indexPath.row].data
        }
        else if contact.infoToDisplay[indexPath.row].action == .CallMobile{
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataClickableCell", for: indexPath) as! TitleDataClickableTableViewCell
            let titleDataTVC = cell as! TitleDataClickableTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.dataLabel.text = contact.infoToDisplay[indexPath.row].data
        }
        else if contact.infoToDisplay[indexPath.row].action == .CallTelephone {
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataClickableCell", for: indexPath) as! TitleDataClickableTableViewCell
            let titleDataTVC = cell as! TitleDataClickableTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.dataLabel.text = contact.infoToDisplay[indexPath.row].data
        }
        else if contact.infoToDisplay[indexPath.row].action == .WriteMail {
            cell = tableView.dequeueReusableCell(withIdentifier: "titleDataCell", for: indexPath) as! TitleDataTableViewCell
            let titleDataTVC = cell as! TitleDataTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.dataLabel.text = contact.infoToDisplay[indexPath.row].data
        }
        else if contact.infoToDisplay[indexPath.row].action == .Edit{
            cell = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
            let titleDataTVC = cell as! TitleClickableTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.titleLabel.textColor = greenKertel
        }
        else if contact.infoToDisplay[indexPath.row].action == .Delete{
            cell = tableView.dequeueReusableCell(withIdentifier: "titleClickableCell", for: indexPath) as! TitleClickableTableViewCell
            let titleDataTVC = cell as! TitleClickableTableViewCell
            titleDataTVC.titleLabel.text = contact.infoToDisplay[indexPath.row].title
            titleDataTVC.titleLabel.textColor = redKertel
        }
        else {
            let empty = UITableViewCell()
            empty.selectionStyle = .none
            return empty
        }
        return cell!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
 case noAction //titleDataTableViewCell
 case callMobile //titleDataClickableTableViewCell
 case callTelephone //titleDataClickableTableViewCell
 case writeMail //titleDataClickableTableViewCell
 case emptyCase
 case edit //titleClickableTableViewCell
 case delete //titleClickableTableViewCell
 
 
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
 return cell!
 }

 */
