//
//  PNNotificationTableViewCell.swift
//  PicNRoll
//
//  Created by new on 1/13/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    func setLabels(_ pnNotification:PNNotification){
        let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : PNGlobal.PNDarkGrayColor]
        let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : PNGlobal.PNDarkGrayColor]
        let attributedString1 = NSMutableAttributedString(string:pnNotification.vendorName, attributes:attrs1)

        if pnNotification.kind == PNGlobal.FOLDER{
            let attributedString2 = NSMutableAttributedString(string:" shared ", attributes:attrs2)
            let attributedString3 = NSMutableAttributedString(string: pnNotification.folderName, attributes:attrs1)
            let attributedString4 = NSMutableAttributedString(string:" folder", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            self.decLabel.attributedText = attributedString1
        }else{
            let attributedString2 = NSMutableAttributedString(string:" added you to the ", attributes:attrs2)
            let attributedString3 = NSMutableAttributedString(string: pnNotification.groupName, attributes:attrs1)
            let attributedString4 = NSMutableAttributedString(string:" group", attributes:attrs2)
            
            attributedString1.append(attributedString2)
            attributedString1.append(attributedString3)
            attributedString1.append(attributedString4)
            self.decLabel.attributedText = attributedString1
        }
        
        self.dateLabel.text = pnNotification.createdDate.toStringForNotification()
        self.vendorImageView.sd_setImage(with: URL(string: pnNotification.vendorImageUrl), placeholderImage: UIImage(named: "ic_man_placeholder"),options:SDWebImageOptions.refreshCached)
    }    
}
