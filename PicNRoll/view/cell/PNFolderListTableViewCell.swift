//
//  PNFolderListTableViewCell.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

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
    }
    
    func initUi(){
        addPictureLabel.layer.cornerRadius = 15
        addPictureLabel.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    
    func setLabels(folder: PNFolder){
        nameLabel.text = folder.name
        vendorLabel.text = folder.vendor
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
