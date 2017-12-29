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
    
    var selectedFolder: PNFolder?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFolder = PNSharePagingViewController.selectedFolder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnShareClicked() {
        if getSelectedFriendContactList(){
            self.shareFolder()
        }else{
            self.showAlarmViewController(message: "Please select friends or contacts to share a folder")
        }
    }
    
    func shareFolder(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.addSharedUserForFolder(pnFoder: self.selectedFolder!,
                                            friendList: self.selectedFriendList,
                                            contactList: self.selectedContactList,
                                            completion: {() in
                                                SVProgressHUD.dismiss()
                                                _ = self.navigationController?.popViewController(animated: true)
                                                
        })
    }
}


