//
//  PNFriendContactsViewController.swift
//  PicNRoll
//
//  Created by diana on 12/28/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD

class PNFriendContactsViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    public var friendList : [PNUser] = []
    public var contactList : [PNUser] = []
    
    public var selectedFriendList : [PNUser] = []
    public var selectedContactList : [PNUser] = []

    let section = ["Friends", "Contacts"]
    
    public var appInviteRecipientList : [String] = []

    @IBOutlet var friendTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUi(){
        friendTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        friendTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        getFriends()
    }
}

extension PNFriendContactsViewController{
    
    func getSelectedFriendContactList() -> Bool{
        if self.friendList.count != 0{
            self.selectedFriendList = self.getSelectedUserList(0, self.friendList)
        }
        if self.contactList.count != 0{
            self.selectedContactList = self.getSelectedUserList(1, self.contactList)
        }
        if (selectedFriendList.count == 0) && (selectedContactList.count == 0){
            return false
        }
        return true
    }
    
    func getFriends(){
        SVProgressHUD.show()
        PNContactManager.shared.syncContacts { (response) in
            SVProgressHUD.dismiss()
            self.friendList = PNContactManager.shared.contactFriendInfo
            self.contactList = PNContactManager.shared.contactUnFriendInfo
            self.friendTableView.reloadData()
        }
    }
    
    func getSelectedUserList(_ section: Int,_ userList: [PNUser]) -> [PNUser]{
        var selectedFriendList : [PNUser] = []
        for i in 0...userList.count-1 {
            let pnUser = userList[i]
            if pnUser.isSelected == true{
                selectedFriendList.append(userList[i])
            }
        }
        return selectedFriendList
    }
}



extension PNFriendContactsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return friendList.count;
        }else{
            return contactList.count;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.friendTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        
        if indexPath.section == 0{
            let pnUser = self.friendList[indexPath.row]
            cell.setLabels(pnUser.name, pnUser.profileImageUrl, false, pnUser.isSelected)
        }else{
            let pnUser = self.contactList[indexPath.row]
            cell.setLabels(pnUser.name, pnUser.profileImageUrl, false, pnUser.isSelected)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let pnUser = self.friendList[indexPath.row]
            pnUser.updateSelectedState()
            self.friendList[indexPath.row] = pnUser
        }else{
            let pnUser = self.contactList[indexPath.row]
            pnUser.updateSelectedState()
            self.contactList[indexPath.row] = pnUser
        }
        self.friendTableView.reloadData()
    }
}

extension PNFriendContactsViewController:MFMailComposeViewControllerDelegate{
    
    func sendEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else {
            self.showAlarmViewController(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        for i in 0...self.selectedFriendList.count-1 {
            self.appInviteRecipientList.append(self.selectedContactList[i].email)
        }
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(self.appInviteRecipientList)
        mailComposerVC.setSubject("PicNRoll App invite")
        mailComposerVC.setMessageBody("Please download PicNRoll in app store" + PNGlobal.PNAppLink, isHTML: false)
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getAppInviteReceipientList(){
    }
}



