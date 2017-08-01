//
//  TitleClickableTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 18/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class TitleClickableTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print("setSelected TitleClickableTableViewCell")
        // Configure the view for the selected state
    }

}
