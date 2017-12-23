//
//  PNPictureViewController.swift
//  PicNRoll
//
//  Created by diana on 12/21/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class PNPictureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initPhotoArrays(){
        var images = [SKPhoto]()
        let photo1 = SKPhoto.photoWithImage(UIImage.init(named: "test.jpeg")!)// add some UIImage
        let photo2 = SKPhoto.photoWithImage(UIImage.init(named: "test.jpeg")!)// add some UIImage
        let photo3 = SKPhoto.photoWithImage(UIImage.init(named: "test.jpeg")!)// add some UIImage
        let photo4 = SKPhoto.photoWithImage(UIImage.init(named: "test.jpeg")!)// add some UIImage

        images.append(photo1)
        images.append(photo2)
        images.append(photo3)
        images.append(photo4)

        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
}
