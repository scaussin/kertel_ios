//
//  CallHistoryTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 25/04/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class CallHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stateCallImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sateCallLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var callHistory : CallHistory? {
        didSet{
            if let call = callHistory{
                nameLabel.text = call.getPresentationName()
            }
        }
    }
    
    
    @IBAction func infoButton(_ sender: Any) {
        print("info j\(String(describing: callHistory?.getPresentationName))")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
