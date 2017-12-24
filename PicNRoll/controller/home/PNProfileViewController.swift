//
//  PNProfileViewController.swift
//  PicNRoll
//
//  Created by jordi on 16/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material
import Firebase
import SVProgressHUD

class PNProfileViewController: PNBaseViewController {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailTextField: ErrorTextField!
    @IBOutlet var pwTextField: ErrorTextField!
    @IBOutlet var mobileTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLabels(){
        nameLabel.text = PNGlobal.currentUser?.name
        emailTextField.text = PNGlobal.currentUser?.email
        mobileTextField.text = PNGlobal.currentUser?.phoneNumber
    }
}
