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
import SDWebImage

class PNProfileViewController: PNBaseViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var emailTextField: ErrorTextField!
    @IBOutlet var pwTextField: ErrorTextField!
    @IBOutlet var mobileTextField: ErrorTextField!
    @IBOutlet var nameTextField: ErrorTextField!
    var currentUser : PNUser!
    
    let imagePicker = UIImagePickerController()

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
        self.profileImageView.sd_setImage(with: URL(string: (PNGlobal.currentUser?.profileImageUrl)!), placeholderImage: UIImage(named: ""),options:SDWebImageOptions.progressiveDownload)
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
                self.updateUserInformationWithEmail()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                alert -> Void in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func updateUserInformationWithEmail(){
        self.view.endEditing(true)
        self.currentUser = PNGlobal.currentUser
        if currentUser?.email != emailTextField.text!{
            currentUser?.email = emailTextField.text!
            SVProgressHUD.show()
            PNFirebaseManager.shared.updateUserEmail(email: (currentUser?.email)!,
                                                completion:{ (error: Error?) in
                                                    if error == nil{
                                                        self.updateUserInformation()
                                                    }else{
                                                        self.showAlarmViewController(message: (error?.localizedDescription)!)
                                                    }
                                                    SVProgressHUD.dismiss()
            })

        }else{
            updateUserInformation()
        }
    }
    
    func updateUserInformation(){
        SVProgressHUD.show()
        currentUser?.name = nameTextField.text!
        currentUser?.phoneNumber = mobileTextField.text!
        PNFirebaseManager.shared.updateUser(pnUser: currentUser!,
                                            completion:{ (error: Error?) in
                                                if error == nil{
                                                    PNGlobal.currentUser = self.currentUser
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

extension PNProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBAction func btnAddPictureClicked(_ sender: UIButton){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.updateProfilePicture(image: chosenImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateProfilePicture(image:UIImage){
        SVProgressHUD.show()
        PNFirebaseManager.shared.updateUserProfile(image: image,
                                                   completion:{ (urlString:String?,error: Error?) in
                                                if error == nil{
                                                    PNGlobal.currentUser?.profileImageUrl = urlString!
                                                    self.profileImageView.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: ""))
                                                }else{
                                                    
                                                }
                                                SVProgressHUD.dismiss()
        })
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


