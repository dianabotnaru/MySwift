//
//  PNGroupInviteViewController.swift
//  PicNRoll
//
//  Created by diana on 12/27/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD


class PNGroupInviteViewController: PNFriendContactsViewController {

    var phoneNumbers : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isAddFriend = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func barButtonDoneClicked() {
        if(self.getSelectedFriendContactList()){
            self.sendInvite()
        }else{
            self.showAlarmViewController(message: "Please select friends or contacts to add in group")
        }
    }
}





