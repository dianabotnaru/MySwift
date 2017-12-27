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

    let cellReuseIdentifier = "PNGroupTableViewCell"
    let section = ["Groups", "Friends"]
    @IBOutlet var groupTableView: UITableView!

    public var groupList : [PNGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        getGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnShareClicked() {
    }
}

extension PNGroupShareViewController{
    func getGroups(){
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
        cell.setNameLabelwithGroup(groupName:self.groupList[indexPath.row].name)
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
        cell.setCheckedState()
    }
}

