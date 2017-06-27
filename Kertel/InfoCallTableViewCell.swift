//
//  InfoCallTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 02/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class InfoCallTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numberButton: UIButton!
    
    var info : (title: String, value: String)? {
    didSet{
        if let info = info{
            titleLabel.text = info.title
            if (self.reuseIdentifier == "detailCellNumber")
            {
                numberButton.setTitle(info.value, for: .normal)
            }
            else
            {
                dataLabel.text = info.value
            }
        }
    }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: true)
    }

}
