//
//  InfoCallTableViewCell.swift
//  Kertel
//
//  Created by Kertel on 02/05/2017.
//  Copyright © 2017 Kertel. All rights reserved.
//

import UIKit

class InfoCallTableViewCell: UITableViewCell {


    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var data: UILabel!
    
    var call : CallHistory? {
        didSet{
            if let call = call{
                title.text = "numéro"
                data.text = call.number
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
