//
//  PNPagingViewController.swift
//  PicNRoll
//
//  Created by diana on 17/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import PagingKit

class PNPagingViewController: UIViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    static let rollsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNRollsViewController") as UIViewController
    static let foldersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNFolderViewController") as UIViewController
    static let groupsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNGroupViewController") as UIViewController
    static let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PNProfileViewController") as UIViewController

    let dataSource = [(menuTitle: "Rolls", vc: rollsViewController), (menuTitle: "Folders", vc: foldersViewController),(menuTitle: "Groups", vc: groupsViewController),(menuTitle: "Profile", vc: profileViewController)]

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



