//
//  TitleDataClickableTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 18/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class TitleDataClickableTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print("setSelected TitleDataClickableTableViewCell")
        // Configure the view for the selected state
    }

}
