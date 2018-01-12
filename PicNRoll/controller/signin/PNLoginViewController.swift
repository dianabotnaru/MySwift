//
//  ViewController.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD

class PNLoginViewController: PNBaseViewController {

    @IBOutlet var emailTextField: ErrorTextField!
    @IBOutlet var pwTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSigninClicked() {
        if(emailTextField.text == ""){
            self.showAlarmViewController(message:"Please enter email!")
            return;
        }
        
        if(!self.isValid(emailTextField.text!)){
            self.showAlarmViewController(message:"Please enter a valid email!")
            return
        }
        
        if(pwTextField.text == ""){
            self.showAlarmViewController(message:"Please enter password!")
            return;
        }
        signin()
    }
    
    @IBAction func btnForgotpasswordClicked() {
        self.pushViewControllerForSignIn(identifier: "PNForgotPwViewController")
    }
    
    @IBAction func btnSignupClicked() {
        self.pushViewControllerForSignIn(identifier: "PNSignupViewController")
    }
    
    func signin(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.signInUser(email: emailTextField.text!,
                                            password: pwTextField.text!,
                                            completion:{ (pnUser: PNUser?,error: Error?) in
                                                if error == nil{
                                                    PNGlobal.currentUser = pnUser
                                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                    appDelegate.launchHomeScreen()
                                                }else{
                                                    self.showAlarmViewController(message: (error?.localizedDescription)!)
                                                }
                                                SVProgressHUD.dismiss()
        })
    }
}

extension PNLoginViewController: TextFieldDelegate{
    
    func initUi(){
        emailTextField.delegate = self
        pwTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(PNSignupViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PNSignupViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
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
}

