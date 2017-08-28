//
//  TitleSwitchTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 28/08/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class TitleSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
