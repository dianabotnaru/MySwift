//
//  PNForgotPwViewController.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD

class PNForgotPwViewController: PNBaseViewController {

    @IBOutlet var emailTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PNSignupViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PNSignupViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        SVProgressHUD.show()
        PNFirebaseManager.shared.forgotPassowrd(email: emailTextField.text!){ (result: String) in
                                                if result == ""{
                                                    self.showAlarmViewController(message:"Submit success! Please check out your email.")
                                                    self.btnCancelClicked()
                                                }else{
                                                    self.showAlarmViewController(message:result)
                                                }
                                                SVProgressHUD.dismiss()
        }
    }
}

extension PNForgotPwViewController: TextFieldDelegate{
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= 220
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 220
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
