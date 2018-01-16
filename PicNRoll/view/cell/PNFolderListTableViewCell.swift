//
//  PNFolderListTableViewCell.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SDWebImage

protocol PNFolderListTableViewCellDelegate: class
{
    func didTapShareButton(index:Int)
    func didAddPictureButtonTapped(_ index:Int, _ sender: UIButton)

}

class PNFolderListTableViewCell: UITableViewCell {
    
    weak var delegate:PNFolderListTableViewCellDelegate?
    
    @IBOutlet var addPictureLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var vendorLabel: UILabel!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var addPictureButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstImageView: UIImageView!

    var index : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        initUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addPictureLabel.backgroundColor = PNGlobal.PNRedColor
    }
    
    func initUi(){
        addPictureLabel.layer.cornerRadius = 15
        addPictureLabel.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    
    func setLabels(folder: PNFolder){
        nameLabel.text = folder.name
        if folder.vendorId == PNFirebaseManager.shared.getCurrentUserID(){
            vendorLabel.text = "me"
        }else{
            vendorLabel.text = folder.vendorName
        }
        firstImageView.sd_setImage(with: URL(string: folder.firstImageUrl), placeholderImage: UIImage(named: ""))
        profileImageView.sd_setImage(with: URL(string: folder.vendorProfileImageUrl), placeholderImage: UIImage(named: "ic_man_placeholder.png"))
    }
    
    func getTimeStringFromDate(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func shareButtonTapped(){
        if delegate != nil{
            self.delegate?.didTapShareButton(index: self.index)
        }
    }
    
    @IBAction func btnAppPictureTapped(_ sender: UIButton) {
        if delegate != nil{
            self.delegate?.didAddPictureButtonTapped(index,sender)
        }

    }
}
