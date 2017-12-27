//
//  PNGroupInviteViewController.swift
//  PicNRoll
//
//  Created by diana on 12/27/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNGroupInviteViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    public var friendList : [PNUser] = []
    public var selectedGroup : PNGroup?

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



