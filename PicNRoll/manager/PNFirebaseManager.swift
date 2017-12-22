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
    
    let USERTABLE = "Users"
    
    var storageRef: StorageReference = Storage.storage().reference()
    var databaseRef: DatabaseReference = Database.database().reference()
    var auth = Auth.auth()
    
    func getCurrentUserID() -> String? {
        return auth.currentUser?.uid
    }
    
    func createUser(email:String,
                 password:String,
                 name:String,
                 phoneNumber : String,
                 lat:String,
                 lng:String,
                 completion: @escaping (PNUser?,Error?) -> Swift.Void){
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
                let pnUser = PNUser()
                pnUser.id = (user?.uid)!
                pnUser.setValues(id: (user?.uid)!, name: name, email: email, phoneNumber: phoneNumber, lat: lat, lng: lng, profileImageUrl: "")
                completion(pnUser,nil)
            }else{
                completion(nil,error)
            }
        }
    }
    func signInUser(email:String,
                  password:String,
                  completion: @escaping (PNUser?,Error?) -> Swift.Void){
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.getUserInformation(userId: (user?.uid)!, completion: {(pnUser: PNUser?,error: Error?) in
                    pnUser?.id = (user?.uid)!
                    completion(pnUser,error)
                })
            }else{
                completion(nil,error)
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
    
    func getUserInformation(userId:String,
                            completion: @escaping (PNUser?,Error?) -> Swift.Void){
        self.databaseRef.child(USERTABLE).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let pnUser = PNUser()
            let value = snapshot.value as? NSDictionary
            pnUser.id = userId
            pnUser.setValuesWithSnapShot(value: value!)
            completion(pnUser,nil)
        }) { (error) in
            completion(nil,error)
        }
    }
}