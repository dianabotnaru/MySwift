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
    
    public var groupMemberList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isAddFriend = true
        self.getFriends(completion:{ () in
            self.getInviteAvailableUserList()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func getInviteAvailableUserList(){
        var availableFriendList : [PNUser] = []
        var availableContactList : [PNUser] = []
        availableFriendList = getInviteAvailableUserList(self.friendList)
        availableContactList = getInviteAvailableUserList(self.contactList)
        self.friendList.removeAll()
        self.contactList.removeAll()
        for friend in availableFriendList{
            self.friendList.append(friend)
        }
        for contact in availableContactList{
            self.contactList.append(contact)
        }
        self.friendTableView.reloadData()
    }
    
    func getInviteAvailableUserList(_ originalList : [PNUser]) -> [PNUser]{
        var availableFriendList : [PNUser] = []
        for friend in originalList{
            var isAlreadyFriend : Bool = false
            for groupmember in self.groupMemberList{
                if (friend.email != "") && (friend.email == groupmember.email){
                    isAlreadyFriend = true
                }
                if (friend.phoneNumber != "") && (friend.phoneNumber == groupmember.phoneNumber){
                    isAlreadyFriend = true
                }
            }
            if isAlreadyFriend == false{
                availableFriendList.append(friend)
            }
        }
        return availableFriendList
    }

    
    @IBAction func barButtonDoneClicked() {
        if(self.getSelectedFriendContactList()){
            self.sendInvite()
        }else{
            self.showAlarmViewController(message: "Please select friends or contacts to add in group")
        }
    }
}





