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

    var inviteList : [PNUser] = []
    var searchList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.searchList = PNContactManager.shared.allPNUser
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
}

extension PNFriendInviteViewController: VENTokenFieldDelegate {
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
//        self.inviteList.append(text)
//        self.inviteListField.reloadData()
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        self.inviteList.remove(at: Int(index))
        self.inviteListField.reloadData()
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeText text: String?) {
    }
    
    func tokenFieldDidBeginEditing(_ tokenField: VENTokenField) {
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeContentHeight height: CGFloat) {
    }
}

extension PNFriendInviteViewController: VENTokenFieldDataSource {
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return self.inviteList[Int(index)].name
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.inviteList.count)
    }
    
    func tokenFieldCollapsedText(_ tokenField: VENTokenField) -> String {
        return ""
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
        self.inviteList.append(searchList[indexPath.row])
        self.inviteListField.reloadData()
    }
}
