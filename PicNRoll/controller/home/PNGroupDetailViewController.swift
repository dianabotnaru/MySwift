//
//  PNGroupDetailViewController.swift
//  PicNRoll
//
//  Created by jordi on 18/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNGroupDetailViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNGroupTableViewCell"
    @IBOutlet var groupMembersTableView: UITableView!
    @IBOutlet var groupImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        groupMembersTableView.register(UINib(nibName: "PNGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        groupMembersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        groupImageView.layer.cornerRadius = 20
        groupImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PNGroupDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.groupMembersTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNGroupTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
