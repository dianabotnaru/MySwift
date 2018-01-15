//
//  PNFriendInviteViewController.swift
//  PicNRoll
//
//  Created by diana on 1/11/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import VENTokenField
import MessageUI
import SVProgressHUD

protocol PNFriendInviteViewControllerDelegate: class
{
    func didAddFriends()
}

class PNFriendInviteViewController: PNBaseViewController {
    
    let cellReuseIdentifier = "PNGroupTableViewCell"

    @IBOutlet var inviteListField: VENTokenField!
    @IBOutlet var searchResultTableView: UITableView!

    @IBOutlet var tableviewTopConstraint: NSLayoutConstraint!
    @IBOutlet var tokenFieldHeight: NSLayoutConstraint!

    @IBOutlet var shareView: UIView!

    public var selectedGroup : PNGroup?
    public var selectedFolder : PNFolder?

    var groupMemberList : [PNUser]?
    var isShareFolder : Bool?

    weak var delegate:PNFriendInviteViewControllerDelegate?

    var inviteList : [PNUser] = []
    var searchList : [PNUser] = []
    var emailInviteList : [PNUser] = []
    var pnUserInviteList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        if isShareFolder == true {
            self.selectedFolder = PNSharePagingViewController.selectedFolder
            self.shareView.isHidden = false
        }
        self.inviteListTokenField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func inviteListTokenField(){
        self.inviteListField.delegate = self as VENTokenFieldDelegate
        self.inviteListField.dataSource = self as VENTokenFieldDataSource
        self.inviteListField.delimiters = [",","--"," "]
        self.inviteListField.toLabelText = "To: "
        self.inviteListField.placeholderText = "Please input friend name or email."
        self.inviteListField.inputTextFieldKeyboardType = UIKeyboardType.emailAddress
        self.inviteListField.autocapitalizationType = UITextAutocapitalizationType.none
        self.inviteListField.reloadData()
    }
    
    func getSearchResults(_ text: String){
        self.searchList.removeAll()
        for pnUser in PNContactManager.shared.allPNUser{
            if pnUser.name.contains(text){
                self.searchList.append(pnUser)
            }else{
                if pnUser.email.contains(text){
                    self.searchList.append(pnUser)
                }
            }
        }
    }
    
    func getPnUserFromText(_ text: String) -> PNUser {
        var selectedUser: PNUser = PNUser()
        for pnUser in PNContactManager.shared.allPNUser{
            if pnUser.name == text{
                selectedUser = pnUser
            }else{
                if pnUser.email == text{
                    selectedUser = pnUser
                }else{
                    if text.isValidEmailAddress() == true{
                        selectedUser.email = text
                        selectedUser.isInvite = true
                    }
                }
            }
        }
        return selectedUser
    }
    
    func isAlreadyAddedUser(_ selectedUser: PNUser) -> Bool{
        for pnUser in self.inviteList{
            if selectedUser.email == pnUser.email{
                return true
            }
        }
        return false
    }
    
    @IBAction func btnWhatsAppClicked() {
        let msg = "Check out PicNRoll for your smartphone. Download it today from " + PNGlobal.PNAppLink
        let urlWhats = "https://api.whatsapp.com/send?text=\(msg)"

        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    self.showAlarmViewController(message: "please install watsapp")
                }
            }
        }
    }
    
    @IBAction func btnDoneClicked() {
        sendInvite()
    }
    
    @IBAction func btnShareClicked() {
        sendInvite()
    }
    
    func sendInvite(){
        if(self.inviteList.count > 0){
            getInviteLists()
            if self.emailInviteList.count > 0{
                self.sendEmail()
            }else{
                if isShareFolder == true{
                    self.shareFolder()
                }else{
                    self.addFriends()
                }
            }
        }else{
            self.showAlarmViewController(message: "Please input friends or emails to add in group")
        }
    }
    
    func getInviteLists(){
        self.emailInviteList.removeAll()
        self.pnUserInviteList.removeAll()
        for pnUser in self.inviteList{
            if pnUser.isInvite == true{
                self.emailInviteList.append(pnUser)
            }else{
                self.pnUserInviteList.append(pnUser)
            }
        }
    }
    
    func addFriends(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.addMembers(pnGroup: self.selectedGroup!,
                                            groupMemberList: self.groupMemberList!,
                                            friendList: self.pnUserInviteList,
                                            contactList: self.emailInviteList,
                                            completion: {() in
                                                self.sendNotification(index: 0)
        })
    }
    
    func shareFolder(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.addSharedUserForFolder(pnFoder: self.selectedFolder!,
                                                        friendList: self.pnUserInviteList,
                                                        contactList: self.emailInviteList,
                                                        completion: {() in
                                                            self.sendNotification(index: 0)
        })
    }
    
    func sendNotification(index:Int){
        let pnUser = self.pnUserInviteList[index]
        var message : String = ""
        if self.isShareFolder == true {
            message = (PNGlobal.currentUser?.name)! + " shared " + (self.selectedFolder?.name)! + " folder"
        }else{
            message = (PNGlobal.currentUser?.name)! + " added you to the " + (self.selectedGroup?.name)!
        }
        PNFirebaseManager.shared.sendNotification(title: "Notification",
                                                  message: message,
                                                  userToken: pnUser.deviceToken,
                                                  completion: {(response) in
                                                    if index < self.pnUserInviteList.count-1{
                                                        self.sendNotification(index: index+1)
                                                    }else{
                                                        SVProgressHUD.dismiss()
                                                        if self.isShareFolder == false{
                                                            if self.delegate != nil {
                                                                self.delegate?.didAddFriends()
                                                            }
                                                        }
                                                        _ = self.navigationController?.popViewController(animated: true)
                                                    }
        })

    }
}

extension PNFriendInviteViewController: VENTokenFieldDelegate {
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        let pnUser = self.getPnUserFromText(text)
        if (pnUser.email != "") && (self.isAlreadyAddedUser(pnUser) == false){
            self.inviteList.append(pnUser)
        }
        self.inviteListField.reloadData()
        self.searchList.removeAll()
        self.searchResultTableView.reloadData()
        self.searchResultTableView.isHidden = true
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        self.inviteList.remove(at: Int(index))
        self.inviteListField.reloadData()
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeText text: String?) {
        self.getSearchResults(text!)
        if self.searchList.count > 0{
            self.searchResultTableView.isHidden = false
            self.searchResultTableView.reloadData()
        }
    }
    
    func tokenFieldDidBeginEditing(_ tokenField: VENTokenField) {
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeContentHeight height: CGFloat) {
        tableviewTopConstraint.constant = height + 10
        tokenFieldHeight.constant = height
    }
}

extension PNFriendInviteViewController: VENTokenFieldDataSource {
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        let pnUser = self.inviteList[Int(index)]
        if pnUser.isInvite == false{
            return self.inviteList[Int(index)].name
        }else{
            return self.inviteList[Int(index)].email + "(invite)"
        }
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.inviteList.count)
    }
    
    func tokenField(_ tokenField: VENTokenField, colorSchemeForTokenAt index: UInt) -> UIColor {
        return PNGlobal.PNColorTextBlueColor
    }
}

extension PNFriendInviteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        let pnUser = searchList[indexPath.row]
        cell.setLabels(pnUser.name + " - " + pnUser.email,pnUser.profileImageUrl,false,false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isAlreadyAddedUser(searchList[indexPath.row]) == false{
            self.inviteList.append(searchList[indexPath.row])
        }
        self.inviteListField.reloadData()
        self.searchList.removeAll()
        self.searchResultTableView.reloadData()
        self.searchResultTableView.isHidden = true
    }
}

extension PNFriendInviteViewController:MFMailComposeViewControllerDelegate{
    
    func sendEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else {
            self.showAlarmViewController(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        var appInviteRecipientList : [String] = []
        for i in 0...self.emailInviteList.count-1 {
            appInviteRecipientList.append(self.emailInviteList[i].email)
        }
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(appInviteRecipientList)
        mailComposerVC.setSubject("PicNRoll App invite")
        mailComposerVC.setMessageBody("Check out PicNRoll for your smartphone. Download it today from " + PNGlobal.PNAppLink, isHTML: false)
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if error != nil {
            self.emailInviteList.removeAll()
            self.showAlarmViewController(message: (error?.localizedDescription)!)
        }
        if isShareFolder == true{
            self.shareFolder()
        }else{
            self.addFriends()
        }
    }
    
    func getAppInviteReceipientList(){
    }
}



