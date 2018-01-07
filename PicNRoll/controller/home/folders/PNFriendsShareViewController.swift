//
//  PNFriendsShareViewController.swift
//  PicNRoll
//
//  Created by diana on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNFriendsShareViewController: PNFriendContactsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isAddFriend = false
        self.selectedFolder = PNSharePagingViewController.selectedFolder
        self.getFriends(completion:{ () in
            self.friendTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnShareClicked() {
        if getSelectedFriendContactList(){
            self.sendInvite()
        }else{
            self.showAlarmViewController(message: "Please select friends or contacts to share a folder")
        }
    }
}


