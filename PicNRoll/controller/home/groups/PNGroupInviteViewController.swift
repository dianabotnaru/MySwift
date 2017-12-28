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

protocol PNGroupInviteViewControllerDelegate: class
{
    func didAddFriends()
}

class PNGroupInviteViewController: PNFriendContactsViewController {
    
    weak var delegate:PNGroupInviteViewControllerDelegate?

    public var selectedGroup : PNGroup?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func barButtonDoneClicked() {
        if getSelectedFriendContactList(){
            self.addFriends()
        }else{
            self.showAlarmViewController(message: "Please select friends or contacts to add in group")
        }
    }
    
    func addFriends(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.addMembers(pnGroup: self.selectedGroup!,
                                            friendList: self.selectedFriendList,
                                            contactList: self.selectedContactList,
                                            completion: {() in
                                                SVProgressHUD.dismiss()
                                                if self.delegate != nil {
                                                    self.delegate?.didAddFriends()
                                                }
                                                _ = self.navigationController?.popViewController(animated: true)

        })
    }
    
    func sendInvite(){
    }
}



