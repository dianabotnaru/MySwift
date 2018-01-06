//
//  PNGroupTableViewCell.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SDWebImage

class PNGroupTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var invitedLabel: UILabel!
    @IBOutlet var checkImageView: UIImageView!

    var isChecked : Bool = false

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
        isChecked = false
    }
    
    func setLabels(_ name: String, _ url:String, _ isInvited: Bool, _ isSelected: Bool){
        self.nameLabel.text = name
        self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic_man_placeholder"),options:SDWebImageOptions.refreshCached)
        checkImageView.isHidden = !isSelected
        self.invitedLabel.isHidden = !isInvited
    }
    
    func setCheckedState(){
        if isChecked == false{
            isChecked = true
            checkImageView.isHidden = false
        }else{
            isChecked = false
            checkImageView.isHidden = true
        }
    }

}
