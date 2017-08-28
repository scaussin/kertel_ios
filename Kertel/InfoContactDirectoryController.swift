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
    var contact : Contact! //set by DirectoryTableViewController
    var indexPath : IndexPath! //set by DirectoryTableViewController
    var parentDirectoryTVC : DirectoryTableViewController! //set by DirectoryTableViewController
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch contact.infoToDisplay[indexPath.row].action! {
        case .CallMobile:
            if let phoneCallURL = URL(string: "tel://\(contact.mobile ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        case .CallTelephone:
            if let phoneCallURL = URL(string: "tel://\(contact.telephone ?? "")") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        case .Edit:
            let newContactDirectoryVC = storyboard?.instantiateViewController(withIdentifier: "newContactTVC") as! NewContactTableViewController
            newContactDirectoryVC.apiController = apiController
            newContactDirectoryVC.contact = contact
            navigationController?.pushViewController(newContactDirectoryVC as UIViewController, animated: true)
        case .Delete:
            let alertController = UIAlertController( title: nil,
                                                     message: nil,
                                                     preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title:"Supprimer ce contact", style: .destructive, handler: {
                action in
                self.parentDirectoryTVC.deleteOneContact(id: (self.contact?.id)!, indexPath: self.indexPath!)
                self.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title:"Annuler", style: .cancel, handler: {
                action in
            })
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        default :
            break
        }
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
