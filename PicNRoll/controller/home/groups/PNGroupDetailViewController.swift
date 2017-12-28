//
//  PNGroupDetailViewController.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNGroupDetailViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    @IBOutlet var groupMembersTableView: UITableView!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupNameLabel: UILabel!

    public var selectedGroup : PNGroup?
    public var groupMemberList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        getGroupMembers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUi(){
        groupMembersTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupMembersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        groupImageView.layer.cornerRadius = 20
        groupImageView.clipsToBounds = true
        groupNameLabel.text = selectedGroup?.name
    }
    
    @IBAction func btnAddClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let groupInviteVC = storyboard.instantiateViewController(withIdentifier: "PNGroupInviteViewController") as! PNGroupInviteViewController
        groupInviteVC.selectedGroup = self.selectedGroup
        groupInviteVC.delegate = self
        self.navigationController?.pushViewController(groupInviteVC, animated: true)
    }
    
    func getGroupMembers(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.getGroupMembers(groupId: (selectedGroup?.id)!, completion: {(memberList: [PNUser]) in
            SVProgressHUD.dismiss()
            self.groupMemberList = memberList
            self.groupMembersTableView.reloadData()
        })
    }
}
extension PNGroupDetailViewController: PNGroupInviteViewControllerDelegate{
    func didAddFriends(){
        getGroupMembers()
    }
}

extension PNGroupDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMemberList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupMembersTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        cell.setNameLabelwithGroup(groupName:self.groupMemberList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.groupMembersTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
        cell.setCheckedState()
    }
}
