//
//  PNRollsTableViewCell.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNRollsTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!

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
}
