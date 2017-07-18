//
//  TitleDataTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 18/07/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class TitleDataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected TitleDataTableViewCell")
        // Configure the view for the selected state
    }

}
