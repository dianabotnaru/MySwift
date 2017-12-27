//
//  AppDelegate.swift
//  PicNRoll
//
//  Created by diana on 14/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Firebase
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()

    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.initNavigationBarUI();
        if Auth.auth().currentUser != nil {
            self.launchHomeScreen()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func initNavigationBarUI(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = PNGlobal.PNPrimaryColor
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBarAppearace.shadowImage = UIImage()
    }
    
    func launchHomeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationViewController") as! UINavigationController
        self.window!.rootViewController = homeNavigationController
        window!.makeKeyAndVisible()
    }
    
    func requestForAccess(completionHandler: @escaping (_ accessGranded: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, accessError) in
                if access {
                    completionHandler(access)
                } else {
                    if authorizationStatus == .denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(title: "Warnning", message: message)
                        })
                    }
                }
            })
        default:
            completionHandler(false)
        }
    }
    
    func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        presentedViewController.present(alertController, animated: true, completion: nil)
    }
}

