//
//  MevoTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 11/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class MevoTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    var mevo : Mevo?
    {
        didSet{
            if let mevo = mevo{
                numberLabel.text = mevo.number
                dateLabel.text = mevo.getShortDate()
                durationLabel.text = mevo.getShortDuration()
            }
        }
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
