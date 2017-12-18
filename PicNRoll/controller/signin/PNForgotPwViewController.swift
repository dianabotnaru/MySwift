//
//  PNForgotPwViewController.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material

class PNForgotPwViewController: PNBaseViewController {

    @IBOutlet var emailTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnForgotpasswordClicked() {
        if emailTextField.text == ""{
            self.showAlarmViewController(message:"Please enter email!")
            return;
        }
        if(!self.isValid(emailTextField.text!)){
            self.showAlarmViewController(message:"Please enter a valid email!")
            return
        }
        fogotPassword()
    }
    
    @IBAction func btnCancelClicked() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func fogotPassword(){
        
    }
}
