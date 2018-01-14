//
//  PNNotificationViewController.swift
//  PicNRoll
//
//  Created by diana on 1/13/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PNNotificationViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNNotificationTableViewCell"
    @IBOutlet var notificationTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.register(UINib(nibName: "PNNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNNotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.notificationTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNNotificationTableViewCell
        cell.setLabels()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
