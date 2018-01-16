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
    
    private let refreshControl = UIRefreshControl()

    public var selectedGroup : PNGroup?
    public var groupMemberList : [PNUser] = []

    var isRefresh : Bool = false
    
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
        initRefreshController()
    }
    
    func initRefreshController(){
        if #available(iOS 10.0, *) {
            groupMembersTableView.refreshControl = refreshControl
        } else {
            groupMembersTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshGroupMembers(_:)), for: .valueChanged)
    }
    
    @objc private func refreshGroupMembers(_ sender: Any) {
        isRefresh = true
        getGroupMembers()
    }

    
    @IBAction func btnAddClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendInviteVC = storyboard.instantiateViewController(withIdentifier: "PNFriendInviteViewController") as! PNFriendInviteViewController
        friendInviteVC.isShareFolder = false
        friendInviteVC.selectedGroup = self.selectedGroup
        friendInviteVC.groupMemberList = self.groupMemberList
        friendInviteVC.delegate = self
        self.navigationController?.pushViewController(friendInviteVC, animated: true)
    }
    
    func getGroupMembers(){
        if self.isRefresh == false {
            SVProgressHUD.show()
        }
        PNFirebaseManager.shared.getGroupMembers(groupId: (selectedGroup?.id)!, completion: {(memberList: [PNUser]) in
            if self.isRefresh == true {
                self.isRefresh = false
                self.refreshControl.endRefreshing()
            }else{
                SVProgressHUD.dismiss()
            }
            self.groupMemberList = memberList
            self.groupMembersTableView.reloadData()
        })
    }
}
extension PNGroupDetailViewController: PNFriendInviteViewControllerDelegate{
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
        let pnUser = self.groupMemberList[indexPath.row]
        if pnUser.name != ""{
            cell.setLabels(pnUser.name, pnUser.profileImageUrl, pnUser.isInvite, false)
        }else{
            cell.setLabels(pnUser.email, pnUser.profileImageUrl, pnUser.isInvite, false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
