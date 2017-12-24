//
//  PNFolderViewController.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class PNFolderViewController: PNBaseViewController{

    let cellReuseIdentifier = "PNFolderListTableViewCell"
    var folderList : [PNFolder] = []

    @IBOutlet var folderTableView: UITableView!
    let imagePicker = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initUi(){
        self.navigationController?.isNavigationBarHidden = false
        folderTableView.register(UINib(nibName: "PNFolderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        folderTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        imagePicker.delegate = self
    }
    
    @IBAction func btnAddClicked() {
        let alertController = UIAlertController(title: "Add a Folder!", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            alert -> Void in
        }))
        alertController.addAction(UIAlertAction(title: "Add", style: .destructive, handler: {
            alert -> Void in
            let nameField = alertController.textFields![0] as UITextField
            if nameField.text == "" {
                self.showAlarmViewController(message:"Please input a folder name.")
                return;
            }
            if self.isExistingFolder(folderName: nameField.text!){
                self.showAlarmViewController(message:"The folder name is aready exist.")
                return;
            }
            self.addFolder(folderName: nameField.text!)
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Please input a folder name."
        })
        self.present(alertController, animated: true, completion: nil)
    }

    func addFolder(folderName: String){
        SVProgressHUD.show()
        let folder = PNFolder() as PNFolder
        folder.setValues(id: PNFirebaseManager.shared.getRamdomID()!,
                         name: folderName,
                         vendorId: (PNGlobal.currentUser?.id)!,
                         vendorName: (PNGlobal.currentUser?.name)!,
                         firstImageUrl: "",
                         createdDate: Date(),
                         isShare: false)
        PNFirebaseManager.shared.createFolder(userId: (PNGlobal.currentUser?.id)!, folder: folder, completion:{ () in
            SVProgressHUD.dismiss()
            self.folderList.append(folder)
            self.reloadData()
        })
    }
    
    func isExistingFolder(folderName: String) -> Bool{
        if self.folderList.count == 0 {
            return false
        }
        
        for i in 0...self.folderList.count-1 {
            let folder = folderList[i] as PNFolder
            if folder.name == folderName{
                return true
            }
        }
        return false
    }
}


extension PNFolderViewController: UITableViewDelegate, UITableViewDataSource ,PNFolderListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 330
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.folderTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNFolderListTableViewCell
        let folder = folderList[indexPath.row] as PNFolder
        cell.setLabels(folder: folder)
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.initBackItemTitle(title: "")
        self.pushViewController(identifier: "PNPictureViewController")
    }
    
    func didTapShareButton(index:Int){
        self.initBackItemTitle(title: "")
        self.pushViewController(identifier: "PNSharePagingViewController")
    }
    
    func didAddPictureButtonTapped(_ index:Int, _ sender: UIButton){
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
    
    func reloadData(){
        self.folderTableView.reloadData()
        DispatchQueue.main.async {
            let itemheight = CGFloat(self.folderList.count) * 350
            if itemheight > self.folderTableView.frame.size.height{
                let scrollPoint = CGPoint(x: 0, y: self.folderTableView.contentSize.height - self.folderTableView.frame.size.height)
                self.folderTableView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
}

extension PNFolderViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
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
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.pushViewController(identifier: "PNPictureViewController")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


