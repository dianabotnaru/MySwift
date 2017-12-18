//
//  PNFolderViewController.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNFolderViewController: PNBaseViewController, UITableViewDelegate, UITableViewDataSource ,PNFolderListTableViewCellDelegate{

    let cellReuseIdentifier = "PNFolderListTableViewCell"
    var floderList : [PNFolder] = []

    @IBOutlet var folderTableView: UITableView!
    @IBOutlet var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initUi(){
        self.navigationController?.isNavigationBarHidden = false
        folderTableView.register(UINib(nibName: "PNFolderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        folderTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        roundedAddButton()
    }
    
    func roundedAddButton(){
        addButton.layer.cornerRadius = 25
        addButton.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.folderTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! PNFolderListTableViewCell
        let folder = floderList[indexPath.row] as PNFolder
        cell.setLabels(folder: folder)
        cell.delegate = self
        cell.index = indexPath.row
        return cell
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
    
    func didTapShareButton(index:Int){
        
    }
    
    func addFolder(folderName: String){
        let folder = PNFolder() as PNFolder
        folder.name = folderName
        folder.createdDate = Date()
        self.floderList.append(folder)
        self.folderTableView.reloadData()
    }
    
    func isExistingFolder(folderName: String) -> Bool{
        if self.floderList.count == 0 {
            return false
        }
        
        for i in 0...self.floderList.count-1 {
            let folder = floderList[i] as PNFolder
            if folder.name == folderName{
                return true
            }
        }
        return false
    }
}
