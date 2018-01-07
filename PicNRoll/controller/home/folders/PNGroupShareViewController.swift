//
//  PNGroupShareViewController.swift
//  PicNRoll
//
//  Created by diana on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNGroupShareViewController: PNBaseViewController {

    var selectedFolder: PNFolder?

    let cellReuseIdentifier = "PNGroupTableViewCell"
    let section = ["Groups", "Friends"]
    @IBOutlet var groupTableView: UITableView!

    public var groupList : [PNGroup] = []
    public var selectedGroupList : [PNGroup] = []
    public var allGroupUserList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedFolder = PNSharePagingViewController.selectedFolder
        groupTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        getGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnShareClicked() {
        getSelectedGroups()
        self.allGroupUserList.removeAll()
        getGroupMembers(index: 0)
        SVProgressHUD.show()
    }
    
    func getGroupMembers(index:Int){
        PNFirebaseManager.shared.getGroupMembers(groupId: selectedGroupList[index].id, completion: {(memberList: [PNUser]) in
            for pnUser in memberList{
                if pnUser.isInvite == false{
                    var isAlreadyAdded : Bool = false
                    for addedUser in self.allGroupUserList{
                        if pnUser.id == addedUser.id{
                            isAlreadyAdded = true
                        }
                    }
                    if isAlreadyAdded == false {
                        self.allGroupUserList.append(pnUser)
                    }
                }
            }
            if index < (self.selectedGroupList.count-1){
                self.getGroupMembers(index: index + 1)
            }else{
                PNFirebaseManager.shared.addSharedUserForFolder(pnFoder: self.selectedFolder!,
                                                                friendList: self.allGroupUserList,
                                                                contactList: [],
                                                                completion: {() in
                                                                    SVProgressHUD.dismiss()
                                                                    self.showAlarmViewController(message: "Folder Share Success!!!")
                })
            }
        })
    }

}

extension PNGroupShareViewController{
    func getGroups(){
        self.groupList.removeAll()
        SVProgressHUD.show()
        PNFirebaseManager.shared.getGroups(userId: (PNGlobal.currentUser?.id)!,completion:{ (groupList: [PNGroup]?,error: Error?) in
            SVProgressHUD.dismiss()
            if error == nil{
                self.groupList = groupList!
                self.groupTableView.reloadData()
            }else{
                self.showAlarmViewController(message:(error?.localizedDescription)!)
            }
        })
    }
    
    func getSelectedGroups(){
        self.selectedGroupList.removeAll()
        for pnGroup in self.groupList{
            if pnGroup.isSelected == true{
                self.selectedGroupList.append(pnGroup)
            }
        }
    }
}


extension PNGroupShareViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        let pnGroup = self.groupList[indexPath.row]
        cell.setLabels(pnGroup.name, pnGroup.groupImageUrl, false, pnGroup.isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select groups to share"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.groupTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
        let pnGroup = self.groupList[indexPath.row]
        pnGroup.updateSelectedState()
        self.groupList[indexPath.row] = pnGroup
        self.groupTableView.reloadData()

    }
}

