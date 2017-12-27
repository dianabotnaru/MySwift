//
//  PNGroupDetailViewController.swift
//  PicNRoll
//
//  Created by diana on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import MessageUI

class PNGroupDetailViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    @IBOutlet var groupMembersTableView: UITableView!
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupNameLabel: UILabel!

    public var selectedGroup : PNGroup?
    public var friendList : [PNUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
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
    }
}

extension PNGroupDetailViewController:MFMailComposeViewControllerDelegate{
    
    func sendEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else {
            self.showAlarmViewController(message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension PNGroupDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
//        return friendList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupMembersTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
//        cell.setNameLabelwithGroup(groupName:self.friendList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.groupMembersTableView.cellForRow(at: indexPath) as! PNGroupTableViewCell
        cell.setCheckedState()
    }
}
