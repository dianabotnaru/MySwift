//
//  PNPictureCollectionViewCell.swift
//  PicNRoll
//
//  Created by new on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNPictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(image:UIImage){
        self.galleryImageView.image = image
    }

}
