//
//  PNFolderViewController.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SVProgressHUD
import Material

class PNFolderViewController: PNBaseViewController{

    let cellReuseIdentifier = "PNFolderListTableViewCell"
    public var folderList : [PNFolder] = []

    @IBOutlet var folderTableView: UITableView!
    @IBOutlet var fabButton: FABButton!

    
    let imagePicker = UIImagePickerController()
   
    var selectedFolder: PNFolder?
    
    private let refreshControl = UIRefreshControl()
    
    var isRefresh : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        getFolderLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initUi(){
        self.navigationController?.isNavigationBarHidden = false
        folderTableView.register(UINib(nibName: "PNFolderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        folderTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        imagePicker.delegate = self
        initRefreshController()
        initFabButton();
    }
    
    func initFabButton(){
        fabButton.pulseColor = .green
        fabButton.backgroundColor = Color.white
        fabButton.tintColor = .black
        fabButton.shadowColor = .black
        fabButton.depthPreset = .depth4
    }
    
    func initRefreshController(){
        if #available(iOS 10.0, *) {
            folderTableView.refreshControl = refreshControl
        } else {
            folderTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshFolderList(_:)), for: .valueChanged)
    }
    
    @objc private func refreshFolderList(_ sender: Any) {
        isRefresh = true
        getFolderLists()
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

extension PNFolderViewController{
    func getFolderLists(){
        if isRefresh == false{
            SVProgressHUD.show()
        }
        PNFirebaseManager.shared.getFolders(completion:{ (folderList: [PNFolder]?,error: Error?) in
            if self.isRefresh == true {
                self.isRefresh = false
                self.refreshControl.endRefreshing()
            }else{
                SVProgressHUD.dismiss()
            }
            if error == nil{
                self.folderList = folderList!
                if folderList?.count == 0{
                    self.showAddFolderAlert()
                }else{
                    self.folderTableView.reloadData()
                }
            }else{
                self.showAlarmViewController(message: (error?.localizedDescription)!)
            }
        })
    }
    
    func showAddFolderAlert(){
        let alert = UIAlertController(title: "No Folders", message: "Do you want to add a folder?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.btnAddClicked();
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addFolder(folderName: String){
        SVProgressHUD.show()
        let folder = PNFolder() as PNFolder
        folder.setValues(id: PNFirebaseManager.shared.getRamdomID()!,
                         name: folderName,
                         vendorId: PNFirebaseManager.shared.getCurrentUserID()!,
                         vendorName: PNGlobal.CURRENT_USER_NAME,
                         vendorProfileImageUrl:PNSharedPreferenceManager.shared.getProfileImageUrl(),
                         firstImageUrl: "",
                         createdDate: Date(),
                         isShare: false)
        PNFirebaseManager.shared.createFolder(folder: folder, completion:{ () in
            SVProgressHUD.dismiss()
            self.folderList.append(folder)
            self.folderTableView.reloadData()
        })
    }
    
    func addPicture(image:UIImage){
        SVProgressHUD.show()
        PNFirebaseManager.shared.addPicture(folderID: (selectedFolder?.id)!, image: image,completion: { (url:String?,error: Error?) in
            SVProgressHUD.dismiss()
            if(error == nil){
                if self.selectedFolder?.firstImageUrl == ""{
                    PNFirebaseManager.shared.setImageUrlofFolder(folderId: (self.selectedFolder?.id)!, vendorId: (self.selectedFolder?.vendorId)!, url: url!, completion: {() in
                        self.launchPictureViewController()
                    })
                }else{
                    self.launchPictureViewController()
                }
            }else{
                self.showAlarmViewController(message: (error?.localizedDescription)!)
            }
        })
    }
    
    func launchPictureViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pictureVC = storyboard.instantiateViewController(withIdentifier: "PNPictureViewController") as! PNPictureViewController
        pictureVC.selectedFolder = selectedFolder
        self.navigationController?.pushViewController(pictureVC, animated: true)
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
        selectedFolder = folderList[indexPath.row]
        if selectedFolder?.firstImageUrl == "" {
            let cell = self.folderTableView.cellForRow(at: indexPath) as! PNFolderListTableViewCell
            showAddPictureAlert(indexPath.row, cell.addPictureButton)
        }else{
            launchPictureViewController()
        }
    }
    
    func showAddPictureAlert(_ index:Int, _ sender: UIButton){
        let alert = UIAlertController(title: "No Pictures", message: "Add Pictures by clicking Picture icon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.didAddPictureButtonTapped(index,sender);
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapShareButton(index:Int){
        selectedFolder = folderList[index]
        PNSharePagingViewController.selectedFolder = selectedFolder!
        self.initBackItemTitle(title: "")
        self.pushViewController(identifier: "PNSharePagingViewController")
    }
    
    func didAddPictureButtonTapped(_ index:Int, _ sender: UIButton){
        selectedFolder = folderList[index]
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.addPicture(image: chosenImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


