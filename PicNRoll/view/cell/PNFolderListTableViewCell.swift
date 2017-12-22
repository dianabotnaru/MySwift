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
    func didAddPictureButtonTapped(index:Int)

}

class PNFolderListTableViewCell: UITableViewCell {
    
    weak var delegate:PNFolderListTableViewCellDelegate?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var photoCountLabel: UILabel!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var addPictureButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!

    var index : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        initUi()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initUi(){
        addPictureButton.layer.cornerRadius = 15
        addPictureButton.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
    }
    
    func setLabels(folder: PNFolder){
        nameLabel.text = folder.name
        dateLabel.text = getTimeStringFromDate(date: folder.createdDate)
        if folder.photoCount == 0{
            photoCountLabel.text = "No photo"
        }else{
            photoCountLabel.text = String((folder.photoCount)) + "Photos"
        }
        if folder.isShare == true{
            shareButton.setBackgroundImage(UIImage.init(named: "ic_share"), for: UIControlState.normal)
        }else{
            shareButton.setBackgroundImage(UIImage.init(named: "ic_noshare"), for: UIControlState.normal)
        }
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
    
    @IBAction func addPictureButtonTapped(){
        if delegate != nil{
            self.delegate?.didAddPictureButtonTapped(index: self.index)
        }
    }
}
