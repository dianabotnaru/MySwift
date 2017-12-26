//
//  PNGroupTableViewCell.swift
//  PicNRoll
//
//  Created by jordi on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNGroupTableViewCell: UITableViewCell {

    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func initUi(){
        groupImageView.layer.cornerRadius = 20
        groupImageView.clipsToBounds = true
    }
    
    func setNameLabelwithGroup(groupName:String){
        nameLabel.text = groupName
    }
}
