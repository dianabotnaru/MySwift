//
//  PNNotificationTableViewCell.swift
//  PicNRoll
//
//  Created by new on 1/13/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PNNotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vendorImageView: UIImageView!
    
    @IBOutlet weak var decLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabels(){
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : PNGlobal.PNDarkGrayColor]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : PNGlobal.PNDarkGrayColor]
        
        let attributedString1 = NSMutableAttributedString(string:"Daniel Ramadan", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:" shared ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:"Wedding Partner", attributes:attrs1)
        let attributedString4 = NSMutableAttributedString(string:" folder", attributes:attrs2)

        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        self.decLabel.attributedText = attributedString1
    }
}
