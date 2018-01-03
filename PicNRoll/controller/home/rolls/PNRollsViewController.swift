//
//  PNRollsViewController.swift
//  PicNRoll
//
//  Created by Diana on 16/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class PNRollsViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNRollsTableViewCell"
    @IBOutlet var rollsTableView: UITableView!
    var rollsList : [PNFolder] = []

    private let refreshControl = UIRefreshControl()

    var isRefresh : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollsTableView.register(UINib(nibName: "PNRollsTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        rollsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        initRefreshController()
        getRollsLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initRefreshController(){
        if #available(iOS 10.0, *) {
            rollsTableView.refreshControl = refreshControl
        } else {
            rollsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshRollsList(_:)), for: .valueChanged)
    }
    
    @objc private func refreshRollsList(_ sender: Any) {
        isRefresh = true
        getRollsLists()
    }

    func getRollsLists(){
        if isRefresh == false{
            SVProgressHUD.show()
        }
        PNFirebaseManager.shared.getFolders(userId: (PNGlobal.currentUser?.id)!, completion:{ (folderList: [PNFolder]?,error: Error?) in
            if self.isRefresh == true {
                self.isRefresh = false
                self.refreshControl.endRefreshing()
            }else{
                SVProgressHUD.dismiss()
            }
            if error == nil{
                self.rollsList = folderList!
                self.rollsTableView.reloadData()
            }else{
                self.showAlarmViewController(message: (error?.localizedDescription)!)
            }
        })
    }

}

extension PNRollsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 330
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rollsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.rollsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNRollsTableViewCell
        cell.setLabels(rollsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pictureVC = storyboard.instantiateViewController(withIdentifier: "PNPictureViewController") as! PNPictureViewController
        pictureVC.selectedFolder = rollsList[indexPath.row]
        self.navigationController?.pushViewController(pictureVC, animated: true)
    }
}
