//
//  TransfertChoiceTVC.swift
//  Kertel
//
//  Created by Kertel on 06/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

enum TypeChoice {
    case Phone
    case Mevo
    case Mobile
    case CustomNumber
    case None
}

class TransfertChoiceTVC: UITableViewController, UITextFieldDelegate {

    var typeTransfert : TypeTransfert! //set by SettingCallTVC (segue)
    var selectedChoice : Int?  //set by SettingCallTVC (segue)
    @IBOutlet weak var titleLabel: UILabel!
    
    var typeChoiceCell : [TypeChoice] = []
    var selectedCell : UITableViewCell?
    
    let phoneChoice  = "Mon poste"
    let mobileChoice  = "Mon mobile"
    let mevoChoice  = "Messagerie vocale"
    let noneChoice  = "Aucun (ne rien faire)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        switch typeTransfert! {
        case .Incoming:
            titleLabel.text = "Transférer tous les appels entrants vers :"
            typeChoiceCell.append(TypeChoice.Phone)
            typeChoiceCell.append(TypeChoice.Mevo)
            typeChoiceCell.append(TypeChoice.Mobile)
            typeChoiceCell.append(TypeChoice.CustomNumber)
        case .Close:
            titleLabel.text = "En cas de non-réponse transférer l'appel vers :"
            typeChoiceCell.append(TypeChoice.Mevo)
            typeChoiceCell.append(TypeChoice.Mobile)
            typeChoiceCell.append(TypeChoice.CustomNumber)
            typeChoiceCell.append(TypeChoice.None)
        case .Busy:
            titleLabel.text = "En cas de d'occupation transférer l'appel vers :"
            typeChoiceCell.append(TypeChoice.Mevo)
            typeChoiceCell.append(TypeChoice.Mobile)
            typeChoiceCell.append(TypeChoice.CustomNumber)
            typeChoiceCell.append(TypeChoice.None)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeChoiceCell.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = UITableViewCell()
        
        switch typeChoiceCell[indexPath.row] {
        case .Phone:
            cell.textLabel?.text = phoneChoice
        case .Mevo:
            cell.textLabel?.text = mevoChoice
        case .Mobile:
            cell.textLabel?.text = mobileChoice
        case .None:
            cell.textLabel?.text = noneChoice
        case .CustomNumber:
            let TTFC : TitleTextFieldTVC = tableView.dequeueReusableCell(withIdentifier: "customNumberCell", for: indexPath) as! TitleTextFieldTVC
            TTFC.customNumber.delegate = self
            cell = TTFC as UITableViewCell
            //cell.textLabel?.text = noneChoice
        }
        
        if selectedChoice == indexPath.row {
            selectedCell = cell
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            print("Parent view loaded")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("okok")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    
        selectedCell?.accessoryType = .none
        selectedChoice = indexPath.row
        
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
        
        /*for i in 0...typeChoiceCell.count {
            if i == indexPath.row {
                tableView.
            }
        }*/
        //tableView.reloadData()
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



}
