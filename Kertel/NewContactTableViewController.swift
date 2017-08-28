//
//  NewContactTableViewController.swift
//  Kertel
//
//  Created by Kertel on 25/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class NewContactTableViewController: UITableViewController {

    var placeholderCell : [(placeholder: String, type: UIKeyboardType?)] = [(placeholder : "Nom", type: .default),
                                                                            (placeholder : "Prénom", type: .default),
                                                                            (placeholder : "Mobile", type: .phonePad),
                                                                            (placeholder : "Téléphone", type: .phonePad),
                                                                            (placeholder : "Société", type: .default),
                                                                            (placeholder : "Mail", type: .emailAddress),
                                                                            (placeholder : "Partager le contact avec l\'entrepise", type: nil)]
    var saveButton : UIBarButtonItem!
    var contact : Contact?
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contact == nil
        {
            subtitleLabel.text = "Modification du contact"
        }
        else
        {
            subtitleLabel.text = "Nouveau contact"
        }
        saveButton = UIBarButtonItem(title : "Enregistrer", style: .plain, target: self, action: #selector(saveButton(sender :)))
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func saveButton(sender : UIBarButtonItem)
    {
        print("save !")
        navigationController?.popViewController(animated: true)
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
        if indexPath.row == 6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleSwitchCell", for: indexPath) as! TitleSwitchTableViewCell
            cell.titleLabel.text = placeholderCell[indexPath.row].placeholder
            cell.switchButton.setOn(false, animated: false)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
        cell.textField.placeholder = placeholderCell[indexPath.row].placeholder
        cell.textField.keyboardType = placeholderCell[indexPath.row].type!
        return cell
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
