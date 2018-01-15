//
//  PNNotificationViewController.swift
//  PicNRoll
//
//  Created by diana on 1/13/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNNotificationViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNNotificationTableViewCell"
    @IBOutlet var notificationTableView: UITableView!
    
    var addedGroupList : [PNGroup] = []
    var sharedFolderList : [PNFolder] = []
    var notificationList : [PNNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.register(UINib(nibName: "PNNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        self.getAddedGroupList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAddedGroupList(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.getGroups(userId: (PNGlobal.currentUser?.id)!,completion:{ (groupList: [PNGroup]?,error: Error?) in
            if error == nil{
                for pnGroup in groupList!{
                    if PNGlobal.currentUser?.id != pnGroup.vendorId{
                        let pnNotification : PNNotification = PNNotification()
                        pnNotification.setValues(pnGroup: pnGroup)
                        self.notificationList.append(pnNotification)
                    }
                }
                self.getSharedFolderList()
            }else{
                SVProgressHUD.dismiss()
                self.showAlarmViewController(message:(error?.localizedDescription)!)
            }
        })

    }
    
    func getSharedFolderList(){
        PNFirebaseManager.shared.getFolders(userId: (PNGlobal.currentUser?.id)!, completion:{ (folderList: [PNFolder]?,error: Error?) in
            SVProgressHUD.dismiss()
            if error == nil{
                for pnFolder in folderList!{
                    if PNGlobal.currentUser?.id != pnFolder.vendorId{
                        let pnNotification : PNNotification = PNNotification()
                        pnNotification.setValues(pnFolder: pnFolder)
                        self.notificationList.append(pnNotification)
                    }
                }
                self.sortNotificationbyDate()
            }else{
                self.showAlarmViewController(message: (error?.localizedDescription)!)
            }
        })
    }
    
    func sortNotificationbyDate(){
        self.notificationList.sort(by: { $0.createdDate.compare($1.createdDate) == .orderedDescending })
        self.notificationTableView.reloadData()
    }
}

extension PNNotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNNotificationTableViewCell
        let pnNotification = self.notificationList[indexPath.row]
        cell.setLabels(pnNotification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
