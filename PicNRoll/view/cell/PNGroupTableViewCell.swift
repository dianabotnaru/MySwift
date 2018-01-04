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
    }
    
    func setNameLabelwithGroup(groupName:String){
        nameLabel.text = groupName
        self.profileImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "ic_group_placeholder"))
    }
    
    func setNameLabelwithFriend(friendName:String){
        nameLabel.text = friendName
        self.profileImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "ic_man_placeholder"))
    }
    
    func setProfileImageWithUrl(url:String){
        self.profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic_man_placeholder"))
    }
    
    func setLabelsWithPnuser(_ pnUser: PNUser){
        self.nameLabel.text = pnUser.name
        self.profileImageView.sd_setImage(with: URL(string: pnUser.profileImageUrl), placeholderImage: UIImage(named: "ic_man_placeholder"))
        if pnUser.isInvite{
            self.invitedLabel.isHidden = false
        }else{
            self.invitedLabel.isHidden = true
        }
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
