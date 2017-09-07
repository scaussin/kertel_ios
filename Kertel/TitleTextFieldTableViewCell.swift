//
//  TitleTextFieldTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 07/09/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class TitleTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var customNumber: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
