//
//  PNFirebaseManager.swift
//  PicNRoll
//
//  Created by diana on 19/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Firebase

final class PNFirebaseManager{
    
    static let shared = PNFirebaseManager()
    
    var storageRef: StorageReference = Storage.storage().reference()
    var databaseRef: DatabaseReference = Database.database().reference()
    var auth = Auth.auth()
    var pnUser = PNUser()
    
    func getCurrentUserID() -> String? {
        return auth.currentUser?.uid
    }
    
    func createUser(email:String,
                 password:String,
                 name:String,
                 phoneNumber : String,
                 lat:String,
                 lng:String,
                 completion: @escaping (String) -> Swift.Void){
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                let post = ["Email": email,
                            "Name": name,
                            "PhoneNumber": phoneNumber,
                            "deviceToken": "",
                            "lat":lat,
                            "lng":lng,
                            "profileImageUrl":""] as [AnyHashable : String]
                self.databaseRef.child("Users").child((user?.uid)!).setValue(post)
                self.pnUser.setValues(id: (user?.uid)!, name: name, email: email, phoneNumber: phoneNumber, lat: lat, lng: lng, profileImageUrl: "")
                completion("")
            }else{
                completion((error?.localizedDescription)!)
            }
        }
    }
    
    func signInUser(email:String,
                  password:String,
                  completion: @escaping (String) -> Swift.Void){
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.databaseRef.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let name = value?["Name"] as? String ?? ""
                    let phoneNumber = value?["PhoneNumber"] as? String ?? ""
                    let lat = value?["lat"] as? String ?? ""
                    let lng = value?["lng"] as? String ?? ""
                    let profileImageUrl = value?["profileImageUrl"] as? String ?? ""
                    self.pnUser.setValues(id: (user?.uid)!, name: name, email: (user?.email)!, phoneNumber: phoneNumber, lat: lat, lng: lng, profileImageUrl: profileImageUrl)
                    completion("")
                }) { (error) in
                    completion(error.localizedDescription)
                }
            }else{
                completion((error?.localizedDescription)!)
            }
        }
    }
    
    func forgotPassowrd(email:String,
                        completion: @escaping (String) -> Swift.Void){
        auth.sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion("")
            }else{
                completion((error?.localizedDescription)!)
            }
        }
    }
}
