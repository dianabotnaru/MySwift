//
//  PNBaseViewController.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initBackItemTitle(title: String) {
        let backItem = UIBarButtonItem()
        backItem.title = title
        navigationItem.backBarButtonItem = backItem
    }

    func pushViewController(identifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as UIViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushViewControllerForSignIn(identifier: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.signInStoryboard?.instantiateViewController(withIdentifier: identifier) as UIViewController?
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func showAlarmViewController(message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
            alert -> Void in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
