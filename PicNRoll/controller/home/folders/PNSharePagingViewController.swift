//
//  PNSharePagingViewController.swift
//  PicNRoll
//
//  Created by diana on 12/22/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import PagingKit
import MessageUI

class PNSharePagingViewController: UIViewController {
    
    static var selectedFolder: PNFolder = PNFolder()
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!

//    static let friendsShareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNFriendsShareViewController") as! PNFriendsShareViewController
    let groupShareViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNGroupShareViewController") as! PNGroupShareViewController
    let friendInviteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNFriendInviteViewController") as! PNFriendInviteViewController
    
    let titleSource = ["Friends","Groups"]
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewController?.register(nib: UINib(nibName: "PNPagingCell", bundle: nil), forCellWithReuseIdentifier: "PNPagingCell")
        menuViewController?.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        menuViewController?.reloadData()
        contentViewController?.reloadData()
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
    
    func performBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension PNSharePagingViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return titleSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return self.view.frame.size.width/2
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "PNPagingCell", for: index) as! PNPagingCell
        cell.titleLabel.text = titleSource[index]
        if index == 0 {
            cell.titleLabel.textColor = .white
        } else {
            cell.titleLabel.textColor = PNGlobal.PNColorTextPlaceHolder
        }
        return cell
    }
}

extension PNSharePagingViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return titleSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        if index == 0 {
            friendInviteViewController.pagingParentVC = self
            self.friendInviteViewController.isShareFolder = true
            return self.friendInviteViewController
        }else {
            return self.groupShareViewController
        }
    }
}

extension PNSharePagingViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        viewController.visibleCells.forEach { $0.isSelected = false }
        viewController.cellForItem(at: page)?.isSelected = true
        contentViewController?.scroll(to: page, animated: true)
    }
}

extension PNSharePagingViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        //        let isRightCellSelected = percent > 0.5
        //        menuViewController?.cellForItem(at: index)?.isSelected = !isRightCellSelected
        //        menuViewController?.cellForItem(at: index + 1)?.isSelected = isRightCellSelected
        //        menuViewController?.scroll(index: index, percent: percent, animated: false)
    }
}



