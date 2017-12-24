//
//  PNRollsViewController.swift
//  PicNRoll
//
//  Created by Diana on 16/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNRollsViewController: PNBaseViewController {

    let cellReuseIdentifier = "PNRollsTableViewCell"
    @IBOutlet var rollsTableView: UITableView!
    var rollsList : [PNFolder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        rollsTableView.register(UINib(nibName: "PNRollsTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        rollsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return cell
    }
}
