//
//  PNRollsTableViewCell.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SDWebImage

class PNRollsTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var folderNameLabel: UILabel!
    @IBOutlet var vendorNameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        initUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initUi(){
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    
    func setLabels(_ pnfolder : PNFolder){
        folderNameLabel.text = pnfolder.name
        if pnfolder.vendorId == PNGlobal.currentUser?.id{
            vendorNameLabel.text = "me"
        }else{
            vendorNameLabel.text = pnfolder.vendorName
        }
        firstImageView.sd_setImage(with: URL(string: pnfolder.firstImageUrl), placeholderImage: UIImage(named: ""))
        profileImageView.sd_setImage(with: URL(string: pnfolder.vendorProfileImageUrl), placeholderImage: UIImage(named: "ic_man_placeholder.png"))
    }
}
