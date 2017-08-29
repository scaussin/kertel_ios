//
//  NewContactTableViewController.swift
//  Kertel
//
//  Created by Kertel on 25/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class NewContactTableViewController: UITableViewController, UITextFieldDelegate, APIControllerProtocol {

    var apiController : APIController? //set by InfoContactDirectoryController
    var placeholderCell : [(placeholder: String, type: UIKeyboardType?)] = [(placeholder : "Nom", type: .default),
                                                                            (placeholder : "Prénom", type: .default),
                                                                            (placeholder : "Mobile", type: .phonePad),
                                                                            (placeholder : "Téléphone", type: .phonePad),
                                                                            (placeholder : "Société", type: .default),
                                                                            (placeholder : "Mail", type: .emailAddress),
                                                                            (placeholder : "Partager le contact avec l\'entrepise", type: nil)]
    var saveButton : UIBarButtonItem!
    var contact : Contact?
    var allTextField = [UITextField?](repeating: nil , count: 6)
    @IBOutlet weak var subtitleLabel: UILabel!
    var pathPutContactDelegate : PathPutContactDelegate!
    var newContact : Contact?
    var switchShared : UISwitch!
    var scaussinCount  = 0
    
    @IBOutlet weak var scaussinImage: UIImageView!
    
    @IBAction func switchscaussinAction(_ sender: Any) {
        scaussinCount += 1
        if scaussinCount % 4 == 0
        {
            scaussinImage.isHidden = false
            print("don't panic")
        }
        else
        {
            scaussinImage.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contact != nil
        {
            subtitleLabel.text = "Modification du contact"
        }
        else
        {
            subtitleLabel.text = "Nouveau contact"
        }
        scaussinImage.image = UIImage(named: "42")
        saveButton = UIBarButtonItem(title : "Enregistrer", style: .plain, target: self, action: #selector(saveButton(sender :)))
        pathPutContactDelegate = PathPutContactDelegate(newContactTVC: self)
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveButton(sender : UIBarButtonItem)
    {
        //nom obligatoire
        if allTextField[0]?.text == nil
        {
            let alert = UIAlertController(title: "", message: "Le champ 'Nom' est obligatoire", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            //modification du contact
            if contact != nil
            {
                newContact = Contact(isUserContact : (contact?.isUserContact)!,
                                     id : contact?.id,
                                     firstname : allTextField[1]?.text,
                                     lastname : allTextField[0]?.text,
                                     company : allTextField[4]?.text,
                                     mobile : allTextField[2]?.text,
                                     telephone : allTextField[3]?.text,
                                     fax : contact?.fax,
                                     mail : allTextField[5]?.text,
                                     shared : switchShared.isOn)
                apiController?.patchContact(delegate: pathPutContactDelegate, contact: newContact)
            }
        }
        //navigationController?.popViewController(animated: true)
    }
    
    // edit or create new contact
    class PathPutContactDelegate : APIDelegate
    {
        var newContactTVC : NewContactTableViewController
        
        init (newContactTVC : NewContactTableViewController!){
            self.newContactTVC = newContactTVC
        }
        
        func success(data: [AnyObject]?) {
            print("APIController.patchContact() success")
            
            DispatchQueue.main.async{
                self.newContactTVC.navigationController?.popViewController(animated: true)
            }
        }
        
        func fail(msgError : String){
            print("APIController.patchContact() fail")
            DispatchQueue.main.sync {
                let alert = UIAlertController(title: "Erreur", message: "Erreur lors de l'enregistrement.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.newContactTVC.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeholderCell.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 6 //switch cell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleSwitchCell", for: indexPath) as! TitleSwitchTableViewCell
            cell.titleLabel.text = placeholderCell[indexPath.row].placeholder
            switchShared = cell.switchButton
            if contact != nil  && contact?.shared != nil {
                cell.switchButton.setOn((contact?.shared!)!, animated: false)
            }
            else{
                cell.switchButton.setOn(false, animated: false)
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            allTextField[indexPath.row] = cell.textField
            cell.textField.tag = indexPath.row //for link return key and switch to the next textField
            cell.textField.placeholder = placeholderCell[indexPath.row].placeholder
            cell.textField.keyboardType = placeholderCell[indexPath.row].type!
            if contact != nil {
                switch indexPath.row {
                case 0:
                    cell.textField.text = contact?.lastname
                case 1:
                    cell.textField.text = contact?.firstname
                case 2:
                    cell.textField.text = contact?.mobile
                case 3:
                    cell.textField.text = contact?.telephone
                case 4:
                    cell.textField.text = contact?.company
                case 5:
                    cell.textField.text = contact?.mail
                default:
                    break
                }
                
            }
            cell.textField.delegate = self
            if indexPath.row == 5 //return key for email field
            {
                cell.textField.returnKeyType = .continue
            }
            else
            {
                cell.textField.returnKeyType = .next
            }
            return cell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag < 5
        {
            allTextField[textField.tag + 1]?.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        return false
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
