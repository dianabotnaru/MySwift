//
//  PNProfileViewController.swift
//  PicNRoll
//
//  Created by diana on 16/12/2017.
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
    @IBOutlet var nameTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLabels(){
        nameTextField.text = PNGlobal.currentUser?.name
        self.nameTextFieldDisable()
        emailTextField.text = PNGlobal.currentUser?.email
        mobileTextField.text = PNGlobal.currentUser?.phoneNumber
    }
    
    @IBAction func btnNameEditClicked(){
        nameTextField.isEnabled = true
        nameTextField.dividerColor = PNGlobal.PNGreenColor
    }
}

extension PNProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextFieldDisable()
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextFieldDisable()
        self.view.endEditing(true)
    }
    
    func nameTextFieldDisable(){
        nameTextField.isEnabled = false
        nameTextField.dividerColor = Color.clear
    }
}
