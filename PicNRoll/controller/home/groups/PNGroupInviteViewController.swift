//
//  PNGroupInviteViewController.swift
//  PicNRoll
//
//  Created by diana on 12/27/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import MessageUI

class PNGroupInviteViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    public var friendList : [PNUser] = []
    public var selectedFriendList : [PNUser] = []
    public var selectedGroup : PNGroup?
    
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
        PNContactManager.shared.syncContacts { (response) in
            self.friendList = PNContactManager.shared.contactBookInfo
            self.friendTableView.reloadData()
        }
    }
    
    @IBAction func barButtonDoneClicked() {
        selectedFriendList = getSelectedFriendList()
        if selectedFriendList.count == 0{
            self.showAlarmViewController(message: "Please select friends to add.")
        }else{
            sendInvite()
        }
    }
    
    func getSelectedFriendList() -> [PNUser]{
        var selectedFriendList : [PNUser] = []
        for i in 0...self.friendList.count-1 {
            let indexPath = IndexPath(item: i, section: 0)
            let cell = self.friendTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
            if cell.isChecked == true{
                selectedFriendList.append(self.friendList[i])
            }
        }
        return selectedFriendList
    }
    
    func sendInvite(){
        self.sendEmail()
    }
}

extension PNGroupInviteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.friendTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        cell.setNameLabelwithGroup(groupName:self.friendList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select friends to add"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.friendTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
        cell.setCheckedState()
    }
}

extension PNGroupInviteViewController:MFMailComposeViewControllerDelegate{
    
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
            self.appInviteRecipientList.append(self.selectedFriendList[i].email)
        }
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(self.appInviteRecipientList)
        mailComposerVC.setSubject("PicNRoll App invite")
        mailComposerVC.setMessageBody("Please download PicNRoll in app store" + PNGlobal.PNAppLink, isHTML: false)
        return mailComposerVC
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getAppInviteReceipientList(){
    }
}




