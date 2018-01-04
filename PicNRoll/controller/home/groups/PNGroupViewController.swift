//
//  PNGroupViewController.swift
//  PicNRoll
//
//  Created by Diana on 16/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNGroupViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    let section = ["Groups", "Friends"]
    @IBOutlet var groupTableView: UITableView!
    private let refreshControl = UIRefreshControl()

    public var groupList : [PNGroup] = []
    public var friendList : [PNUser] = []

    var isRefresh : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        initRefreshController()
        getFriends()
        getGroups()
    }
    
    func initRefreshController(){
        if #available(iOS 10.0, *) {
            groupTableView.refreshControl = refreshControl
        } else {
            groupTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshFriendContactList(_:)), for: .valueChanged)
    }
    
    @objc private func refreshFriendContactList(_ sender: Any) {
        isRefresh = true
        getFriends()
        getGroups()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAddClicked() {
        let alertController = UIAlertController(title: "Add a Group!", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            alert -> Void in
        }))
        alertController.addAction(UIAlertAction(title: "Add", style: .destructive, handler: {
            alert -> Void in
            let nameField = alertController.textFields![0] as UITextField
            if nameField.text == "" {
                self.showAlarmViewController(message:"Please input a folder name.")
                return;
            }
            if self.isExistingGroup(groupName: nameField.text!){
                self.showAlarmViewController(message:"The folder name is aready exist.")
                return;
            }
            self.createGroup(groupName: nameField.text!)
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Please input a folder name."
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isExistingGroup(groupName: String) -> Bool{
        if self.groupList.count == 0 {
            return false
        }
        
        for i in 0...self.groupList.count-1 {
            let group = groupList[i] as PNGroup
            if group.name == groupName{
                return true
            }
        }
        return false
    }
}

extension PNGroupViewController{
    
    func getFriends(){
        if isRefresh == false{
            SVProgressHUD.show()
        }
        PNContactManager.shared.syncContacts { (response) in
            if self.isRefresh == true {
                self.isRefresh = false
                self.refreshControl.endRefreshing()
            }else{
                SVProgressHUD.dismiss()
            }
            SVProgressHUD.dismiss()
            self.friendList = PNContactManager.shared.contactFriendInfo
            self.groupTableView.reloadData()
        }
    }
    
    func getGroups(){
        if isRefresh == false{
            SVProgressHUD.show()
        }
        PNFirebaseManager.shared.getGroups(userId: (PNGlobal.currentUser?.id)!,completion:{ (groupList: [PNGroup]?,error: Error?) in
            if self.isRefresh == true {
                self.isRefresh = false
                self.refreshControl.endRefreshing()
            }else{
                SVProgressHUD.dismiss()
            }
            if error == nil{
                self.groupList = groupList!
                self.groupTableView.reloadData()
            }else{
                self.showAlarmViewController(message:(error?.localizedDescription)!)
            }
        })
    }
    
    func createGroup(groupName:String){
        SVProgressHUD.show()
        PNFirebaseManager.shared.createGroup(userId: (PNGlobal.currentUser?.id)!, groupName: groupName, completion:{ () in
            SVProgressHUD.dismiss()
            self.getGroups()
        })
    }
}

extension PNGroupViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.groupList.count
        }else{
            return self.friendList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        if indexPath.section == 0{
            cell.setNameLabelwithGroup(groupName:self.groupList[indexPath.row].name)
        }else{
            cell.setNameLabelwithFriend(friendName:self.friendList[indexPath.row].name)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.initBackItemTitle(title: "Back to groups")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let groupDetailVC = storyboard.instantiateViewController(withIdentifier: "PNGroupDetailViewController") as! PNGroupDetailViewController
            groupDetailVC.selectedGroup = self.groupList[indexPath.row]
            navigationController?.pushViewController(groupDetailVC, animated: true)
        }
    }
}
