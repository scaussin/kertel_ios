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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //refresh
        /*refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        view.addSubview(refresher)*/

        // Do any additional setup after loading the view.
    }

    func refresh(){
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
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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

    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transfertChoiceTVC =  segue.destination as! TransfertChoiceTVC
        
        switch segue.identifier! {
        case "toIncomingChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Incoming
            transfertChoiceTVC.selectedChoice = 3 //TODO
        case "toCloseChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Close
            transfertChoiceTVC.selectedChoice = 0 //TODO
        case "toBusyChoiceSegue":
            transfertChoiceTVC.typeTransfert = TypeTransfert.Busy
            transfertChoiceTVC.selectedChoice = 0 //TODO
        default:
            break
        }
    }

}
