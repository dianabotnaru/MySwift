//
//  PNSignupViewController.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD


class PNSignupViewController: PNBaseViewController {
    
    @IBOutlet var nameTextField: ErrorTextField!
    @IBOutlet var emailTextField: ErrorTextField!
    @IBOutlet var phoneNumberTextField: ErrorTextField!
    @IBOutlet var pwTextField: ErrorTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSignupClicked() {
        if nameTextField.text == ""{
            self.showAlarmViewController(message:"Please enter name!")
            return;
        }
        if emailTextField.text == ""{
            self.showAlarmViewController(message:"Please enter email!")
            return;
        }
        if phoneNumberTextField.text == ""{
            self.showAlarmViewController(message:"Please enter phone number!")
            return;
        }
        if pwTextField.text == ""{
            self.showAlarmViewController(message:"Please enter password!")
            return;
        }
        if(!self.isValid(emailTextField.text!)){
            self.showAlarmViewController(message:"Please enter a valid email!")
            return
        }
        signup()
    }
    
    @IBAction func btnSigninClicked() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func signup(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.createUser(email: emailTextField.text!,
                                            password: pwTextField.text!,
                                            name: nameTextField.text!,
                                            phoneNumber: phoneNumberTextField.text!,
                                            lat: "",
                                            lng: ""){ (result: String) in
                                                if result == ""{
                                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                    appDelegate.launchHomeScreen()
                                                    self.pushViewController(identifier: "PNFolderViewController")
                                                }else{
                                                    self.showAlarmViewController(message:result)
                                                }
                                                SVProgressHUD.dismiss()
        }
    }
}

extension PNSignupViewController: TextFieldDelegate{
    
    func initUi(){
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
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
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 220
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


