//
//  PNFriendInviteViewController.swift
//  PicNRoll
//
//  Created by diana on 1/11/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import VENTokenField

class PNFriendInviteViewController: UIViewController {
    
    let cellReuseIdentifier = "PNGroupTableViewCell"

    @IBOutlet var inviteListField: VENTokenField!
    @IBOutlet var searchResultTableView: UITableView!

    @IBOutlet var tableviewTopConstraint: NSLayoutConstraint!
    @IBOutlet var tokenFieldHeight: NSLayoutConstraint!

    var inviteList : [PNUser] = []
    var searchList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.inviteListTokenField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func inviteListTokenField(){
        self.inviteListField.delegate = self as VENTokenFieldDelegate
        self.inviteListField.dataSource = self as VENTokenFieldDataSource
        self.inviteListField.delimiters = [",","--"," "]
        self.inviteListField.becomeFirstResponder()
        self.inviteListField.toLabelText = "To: "
        self.inviteListField.inputTextFieldKeyboardType = UIKeyboardType.emailAddress
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
        self.searchResultTableView.reloadData()
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
    
    @IBAction func btnDoneClicked() {
        self.inviteListField.becomeFirstResponder()
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
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        self.inviteList.remove(at: Int(index))
        self.inviteListField.reloadData()
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeText text: String?) {
        self.getSearchResults(text!)
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
    
//    func tokenFieldCollapsedText(_ tokenField: VENTokenField) -> String {
//        return ""
//    }
    
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
    }
}
