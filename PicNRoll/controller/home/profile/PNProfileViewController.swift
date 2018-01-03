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
    
    @IBAction func btnSaveClicked(){
        if isValidationInputs(){
            let alertController = UIAlertController(title: nil, message: "Are you sure want to update profile information?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                self.updateUserInformation()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                alert -> Void in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateUserInformation(){
        let currentUser = PNGlobal.currentUser
        currentUser?.name = nameTextField.text!
        currentUser?.phoneNumber = mobileTextField.text!
        currentUser?.email = emailTextField.text!
        self.view.endEditing(true)
        SVProgressHUD.show()
        PNFirebaseManager.shared.updateUser(pnUser: currentUser!,
                                            completion:{ (error: Error?) in
                                                if error == nil{
                                                    PNGlobal.currentUser = currentUser
                                                    self.initLabels()
                                                }else{
                                                    self.showAlarmViewController(message: (error?.localizedDescription)!)
                                                }
                                                SVProgressHUD.dismiss()
        })
    }
    
    func isValidationInputs() -> Bool{
        
        if(nameTextField.text == ""){
            self.showAlarmViewController(message:"Please enter password!")
            return false
        }
        if(emailTextField.text == ""){
            self.showAlarmViewController(message:"Please enter email!")
            return false
        }
        
        if(!self.isValid(emailTextField.text!)){
            self.showAlarmViewController(message:"Please enter a valid email!")
            return false
        }
        
        if(mobileTextField.text == ""){
            self.showAlarmViewController(message:"Please enter password!")
            return false
        }
        return true
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
