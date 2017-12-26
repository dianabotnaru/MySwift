//
//  PNPictureCollectionViewCell.swift
//  PicNRoll
//
//  Created by new on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SDWebImage

class PNPictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(image:UIImage){
        self.galleryImageView.image = image
    }
    
    func setImageWithUrl(url:String){
        self.galleryImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "logo"))
    }
}
