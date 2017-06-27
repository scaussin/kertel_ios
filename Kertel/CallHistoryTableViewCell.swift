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
    
    var call : CallHistory? {
        didSet{
            if let call = call{
                nameLabel.text = call.getPresentationName()
                dateLabel.text = call.getShortDate()
                sateCallLabel.text = call.getStateSmart()
                stateCallImage.image = stateCallImage.image!.withRenderingMode(.alwaysTemplate)
                if (call.isIncoming)
                {
                    stateCallImage.transform = CGAffineTransform(scaleX: 1, y: 1);
                }
                else
                {
                    stateCallImage.transform = CGAffineTransform(scaleX: -1, y: -1);
                }
                if (call.isMissed())
                {
                    stateCallImage.tintColor = UIColor(hex: "F15A2F")
                }
                else
                {
                    stateCallImage.tintColor = UIColor.black
                }
            }
        }
    }
    
    
    
    @IBAction func infoButton(_ sender: Any) {
        print("info j\(String(describing: call?.getPresentationName))")
        
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
