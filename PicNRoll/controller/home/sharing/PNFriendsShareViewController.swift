//
//  PNFriendsShareViewController.swift
//  PicNRoll
//
//  Created by diana on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNFriendsShareViewController: UIViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    let section = ["Groups", "Friends"]
    public var friendsList : [PNUser] = []

    @IBOutlet var groupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnShareClicked() {
    }
}

extension PNFriendsShareViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
//        return friendsList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
//        cell.setNameLabelwithGroup(groupName:self.friendsList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select friends to share"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.groupTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
        cell.setCheckedState()
    }
}
