//
//  InfoCallViewController.swift
//  Kertel
//
//  Created by Kertel on 09/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class InfoCallViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var call : CallHistory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = call?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InfoCallTableViewController, segue.identifier == "infoCallEmbed" {
            
            vc.call = self.call
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


class InfoCallTableViewController: UITableViewController {
    
    var call : CallHistory?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! InfoCallTableViewCell
        cell.call = self.call
        return cell
    }
    
    
}
