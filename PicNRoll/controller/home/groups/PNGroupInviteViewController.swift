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
    var phoneNumbers : [String]?
    
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
        self.sendInvite()

//        SVProgressHUD.show()
//        PNFirebaseManager.shared.addMembers(pnGroup: self.selectedGroup!,
//                                            friendList: self.selectedFriendList,
//                                            contactList: self.selectedContactList,
//                                            completion: {() in
//                                                SVProgressHUD.dismiss()
//                                                if self.delegate != nil {
//                                                    self.delegate?.didAddFriends()
//                                                }
//                                                self.sendInvite()
//        })
    }
    
}

extension PNGroupInviteViewController: MFMessageComposeViewControllerDelegate {
    
    func sendInvite(){
        if self.selectedContactList.count > 0{
            for pnContact in self.selectedContactList{
                phoneNumbers?.append(pnContact.phoneNumber)
            }
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Message Body"
                controller.recipients = phoneNumbers
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
}



