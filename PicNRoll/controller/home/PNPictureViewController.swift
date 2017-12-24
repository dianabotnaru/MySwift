//
//  PNPictureViewController.swift
//  PicNRoll
//
//  Created by diana on 12/21/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class PNPictureViewController: UIViewController, SKPhotoBrowserDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [SKPhotoProtocol]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayStatusbar = true
        collectionView.register(UINib(nibName: "PNPictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PNPictureCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        initPhotoArrays()
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createLocalPhotos() -> [SKPhotoProtocol] {
        return (0..<10).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImage(UIImage(named: "test.jpeg")!)
            //            photo.contentMode = .ScaleAspectFill
            return photo
        }
    }

    func initPhotoArrays(){
        images = createLocalPhotos()
        
    }
}

// MARK: - UICollectionViewDataSource
extension PNPictureViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PNPictureCollectionViewCell",
                                                      for: indexPath) as! PNPictureCollectionViewCell
        cell.setImage(image:UIImage(named: "test.jpeg")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width:collectionView.frame.width/5-5, height: collectionView.frame.width/5-5)
        }else{
            return CGSize(width:collectionView.frame.width/2-1, height: collectionView.frame.width/2-1)
        }
    }

    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.row)
        browser.delegate = self
        //        browser.updateCloseButton(UIImage(named: "image1.jpg")!)
        
        present(browser, animated: true, completion: {})
    }
}


// MARK: - SKPhotoBrowserDelegate
extension PNPictureViewController {
    func didShowPhotoAtIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        collectionView.visibleCells.forEach({$0.isHidden = false})
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
    }
    
    func willShowActionSheet(_ photoIndex: Int) {
        // do some handle if you need
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = false
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        // handle dismissing custom actions
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        reload()
    }
    
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return collectionView.cellForItem(at: IndexPath(item: index, section: 0))
    }
}

