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
    case Other //config complexe
    case None //ne rien faire
}

let phoneChoice = "Mon poste"
let mobileChoice = "Mon mobile"
let mevoChoice = "Messagerie vocale"
let customNumberChoice = "Numéro :"
let noneChoice = "Aucun"
let noneChoiceDescription = "(ne rien faire)"
let otherChoice = "Autre"
let otherChoiceDescription = "(configuration personnalisée)"

let choiceTable : [TypeChoice: [String?]] = [TypeChoice.Phone : [phoneChoice],
                                             TypeChoice.Mevo : [mevoChoice],
                                             TypeChoice.Mobile : [mobileChoice],
                                             TypeChoice.CustomNumber : [customNumberChoice],
                                             TypeChoice.Other : [otherChoice, otherChoiceDescription],
                                             TypeChoice.None : [noneChoice, noneChoiceDescription]]

class TransfertChoiceTVC: UITableViewController, UITextFieldDelegate {

    var typeTransfert : TypeTransfert! //set by SettingCallTVC (segue)
    var selectedChoice : TypeChoice!  //set by SettingCallTVC (segue) and updated by user choice
    var settingCallTVC : SettingCallTVC! //set by SettingCallTVC (segue)

    @IBOutlet weak var titleLabel: UILabel!
    
    var typeChoiceCell : [TypeChoice] = []
    var selectedCell : UITableViewCell?

    var customNumberTF : UITextField?
    var indexPathCustomNumber : IndexPath?
    
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
        case .Other:
            cell.textLabel?.text = otherChoice
        case .CustomNumber:
            cell.textLabel?.text = noneChoice
            indexPathCustomNumber = indexPath
            let TTFC : TitleTextFieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "titleTextFieldCell", for: indexPath) as! TitleTextFieldTableViewCell
            TTFC.customNumber.delegate = self
            customNumberTF = TTFC.customNumber
            cell = TTFC as UITableViewCell
        }
        
        if selectedChoice == typeChoiceCell[indexPath.row] {
            selectedCell = cell
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            if selectedChoice == TypeChoice.CustomNumber {
                settingCallTVC.updateChoice(typeTransfert : typeTransfert, selectedChoice : selectedChoice, numberCustom: customNumberTF?.text)
            }
            else {
                settingCallTVC.updateChoice(typeTransfert : typeTransfert, selectedChoice : selectedChoice)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSelectedCell(indexPath: indexPathCustomNumber!)
    }
    
    func updateSelectedCell(indexPath: IndexPath){
        
        selectedCell?.accessoryType = .none
        selectedChoice = typeChoiceCell[indexPath.row]
        
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = .checkmark
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        customNumberTF?.resignFirstResponder()
        updateSelectedCell(indexPath: indexPath)
    }

}
