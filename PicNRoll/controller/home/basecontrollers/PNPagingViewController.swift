//
//  PNPagingViewController.swift
//  PicNRoll
//
//  Created by diana on 17/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import PagingKit
import SVProgressHUD
import Firebase

class PNPagingViewController: PNBaseViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    var folderList : [PNFolder] = []
    
    static let rollsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNRollsViewController") as UIViewController
    static let foldersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNFolderViewController") as! PNFolderViewController
    static let groupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNGroupViewController") as UIViewController
    static let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNProfileViewController") as UIViewController

    let dataSource = [(menuTitle: "Rolls", vc: rollsViewController), (menuTitle: "Folders", vc: foldersViewController),(menuTitle: "Groups", vc: groupsViewController),(menuTitle: "Profile", vc: profileViewController)]

    override func viewDidLoad() {
        super.viewDidLoad()
        if PNGlobal.currentUser == nil{
            getUserInformation()
        }else{
            initPagingViewController()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PagingMenuViewController {
            menuViewController = vc
            menuViewController?.delegate = self
            menuViewController.dataSource = self
        } else if let vc = segue.destination as? PagingContentViewController {
            contentViewController = vc
            contentViewController?.delegate = self
            contentViewController.dataSource = self
        }
    }
    
    func initPagingViewController(){
        menuViewController?.register(nib: UINib(nibName: "PNPagingCell", bundle: nil), forCellWithReuseIdentifier: "PNPagingCell")
        menuViewController?.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        menuViewController?.reloadData()
        contentViewController?.reloadData()
    }
    
    func getUserInformation(){
        SVProgressHUD.show()
        PNFirebaseManager.shared.getUserInformation(userId: (Auth.auth().currentUser!.uid), completion: {(pnUser: PNUser?,error: Error?) in
            SVProgressHUD.dismiss()
            if error == nil {
                PNGlobal.currentUser = pnUser
                self.initPagingViewController()
            }else{
                self.showAlarmViewController(message: (error?.localizedDescription)!)
            }
        })
    }
}

extension PNPagingViewController{
    
    @IBAction func btnMoreClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Notifications", style: .default, handler: { _ in
            self.gotoNotificationVC()
        }))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { _ in
            self.signOut()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.barButtonItem = sender
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        alert.view.tintColor = PNGlobal.PNPrimaryColor
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOut(){
        PNFirebaseManager.shared.SignOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.launchHomeScreen()
    }
    
    func gotoNotificationVC(){
        
    }
}

extension PNPagingViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return self.view.frame.size.width/4
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "PNPagingCell", for: index) as! PNPagingCell
        cell.titleLabel.text = dataSource[index].menuTitle
        if index == 0 {
            cell.titleLabel.textColor = .white
        } else {
            cell.titleLabel.textColor = PNGlobal.PNColorTextPlaceHolder
        }
        return cell
    }
}

extension PNPagingViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].vc
    }
}

extension PNPagingViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        viewController.visibleCells.forEach { $0.isSelected = false }
        viewController.cellForItem(at: page)?.isSelected = true
        contentViewController?.scroll(to: page, animated: true)
    }
}

extension PNPagingViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        let isRightCellSelected = percent > 0.5
        menuViewController?.cellForItem(at: index)?.isSelected = !isRightCellSelected
        menuViewController?.cellForItem(at: index + 1)?.isSelected = isRightCellSelected
        menuViewController?.scroll(index: index, percent: percent, animated: false)
    }
}



