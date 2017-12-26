//
//  PNPagingCell.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import PagingKit

class PNPagingCell: PagingMenuViewCell {
    static let sizingCell = UINib(nibName: "PNPagingCell", bundle: nil).instantiate(withOwner: self, options: nil).first as! PNPagingCell
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = .white
            } else {
                titleLabel.textColor = PNGlobal.PNColorTextPlaceHolder
            }
        }
    }

}
