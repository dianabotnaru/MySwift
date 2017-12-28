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
    let ALBUMTABLE = "Albums"
    let PHOTOFILED = "Photos"
    let GROUPTABLE = "Groups"

    var storageRef: StorageReference = Storage.storage().reference()
    var databaseRef: DatabaseReference = Database.database().reference()
    var auth = Auth.auth()
    
    func getCurrentUserID() -> String? {
        return auth.currentUser?.uid
    }
    
    func getRamdomID() -> String? {
        return  getCurrentUserID()! + "_" + Date().timeStampString()
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
    
    func createFolder(userId:String,
                            folder:PNFolder,
                            completion: @escaping () -> Swift.Void){
        let post = ["id": folder.id,
                    "name": folder.name,
                    "vendorId": folder.vendorId,
                    "vendorName": folder.vendorName,
                    "createdDate": folder.createdDate.toString(),
                    "isShare": folder.isShare,
                    "firstImageUrl":""] as [AnyHashable : AnyObject]
        self.databaseRef.child(ALBUMTABLE).child(getCurrentUserID()!).child(folder.id).setValue(post)
        completion()
    }
    
    func getFolders(userId:String,
                      completion: @escaping ([PNFolder]?,Error?) -> Swift.Void){
        self.databaseRef.child(ALBUMTABLE).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            var folderList : [PNFolder] = []
            for snapshot in snapshot.children.allObjects as! [DataSnapshot]{
                let pnFolder = PNFolder()
                let value = snapshot.value as? NSDictionary
                pnFolder.setValuesWithSnapShot(value: value!)
                folderList.append(pnFolder)
            }
            completion(folderList,nil)
        }) { (error) in
            completion(nil,error)
        }
    }
    
    func addPicture(userId:String,
                    folderID:String,
                    image : UIImage,
                    completion: @escaping (Error?) -> Swift.Void){
        let photoId = getRamdomID() as String?
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let riversRef = storageRef.child("Files/"+userId+"/"+photoId!+".jpg")
        riversRef.putData(imageData!, metadata: nil) { (metadata, error) in
            if error == nil{
                let downloadURL = metadata?.downloadURL()
                let post = ["id": photoId,
                            "name": "",
                            "vendorId": userId,
                            "vendorName": PNGlobal.currentUser?.name,
                            "createdDate": Date().toString(),
                            "imageUrl":downloadURL?.absoluteString] as [AnyHashable : AnyObject]
                self.databaseRef.child(self.ALBUMTABLE).child(userId).child(folderID).child(self.PHOTOFILED).child(photoId!).setValue(post)
            }
            completion(error)
        }
    }
    
    func getPictures(userId:String,
                    folderID:String,
                    completion: @escaping ([PNPhoto]?,Error?) -> Swift.Void){
        self.databaseRef.child(ALBUMTABLE).child(userId).child(folderID).child(self.PHOTOFILED).observeSingleEvent(of: .value, with: { (snapshot) in
            var photoList : [PNPhoto] = []
            for snapshot in snapshot.children.allObjects as! [DataSnapshot]{
                let pnPhoto = PNPhoto()
                let value = snapshot.value as? NSDictionary
                pnPhoto.setValuesWithSnapShot(value: value!)
                photoList.append(pnPhoto)
            }
            completion(photoList,nil)
        }) { (error) in
            completion(nil,error)
        }
    }
    
    func createGroup(userId:String,
                     groupName:String,
                      completion: @escaping () -> Swift.Void){
        let groupId = getRamdomID() as String?
        let post = ["id": groupId,
                    "name": groupName,
                    "vendorId": userId,
                    "vendorName": PNGlobal.currentUser?.name,
                    "createdDate": Date().toString()] as [AnyHashable : AnyObject]
        self.databaseRef.child(GROUPTABLE).child(userId).child(groupId!).setValue(post)
        completion()
    }
    
    func getGroups(userId:String,
                     completion: @escaping ([PNGroup]?,Error?) -> Swift.Void){
        self.databaseRef.child(GROUPTABLE).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            var groupList : [PNGroup] = []
            for snapshot in snapshot.children.allObjects as! [DataSnapshot]{
                let pnGroup = PNGroup()
                let value = snapshot.value as? NSDictionary
                pnGroup.setValuesWithSnapShot(value: value!)
                groupList.append(pnGroup)
            }
            completion(groupList,nil)
        }) { (error) in
            completion(nil,error)
        }
    }

    func generatedID(){
        return
    }
    
    func getAllUsers(completion: @escaping ([PNUser]) -> Swift.Void){
        var usersArr: [PNUser] = []
        databaseRef.child(USERTABLE).observeSingleEvent(of: .value, with: {snapshot in
            for snapshot in snapshot.children.allObjects as! [DataSnapshot]{
                let pnUser = PNUser()
                let value = snapshot.value as? NSDictionary
                pnUser.setValuesWithSnapShot(value: value!)
                usersArr.append(pnUser)
                completion(usersArr)
            }
        })
    }
    
    func getUserFriendIds(block: @escaping ([String]) -> Swift.Void) {
        guard let userId = getCurrentUserID() else {return}
        var ids: [String] = []
        databaseRef.child(USERTABLE).child(userId).child("friends").observeSingleEvent(of: .value, with: { friends in
            if let friendsJson = friends.value as? NSDictionary {
                for (key, _) in friendsJson {
                    ids.append(key as! String)
                }
            }
            block(ids)
        })
    }

    func addNewFriend(friendID:String,
                      completion: @escaping (Error?) -> Swift.Void) {
        guard let userID = getCurrentUserID() else { return }
        databaseRef.child(USERTABLE).child(userID).child("friends").child(friendID).setValue(true) { error, ref in
            if error != nil {
                self.databaseRef.child(self.USERTABLE).child(friendID).child("friends").child(userID).setValue(true) { error, ref in
                    completion(error)
                }
            }else{
                completion(error)
            }
        }
    }
    
    func syncAppContacts(emails: [String]) {
        getAllUsers { (allUsers) in
            if allUsers.count > 0 {
                
                self.getUserFriendIds(block: { (friendIds) in
                    
                    var updateFriends = false
                    for user in allUsers {
                        if !friendIds.contains(user.id) {
                            if !(user.email.isEmpty) {
                                
                                if emails.contains(user.email) {
                                    self.addNewFriend(friendID: user.id, completion: { (error: Error?) in
                                        
                                    })
                                    updateFriends = true
                                }
                                
                            }
                        }
                    }
                    
                    if updateFriends {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updated_friends"), object: nil)
                    }
                    
                })
                
            }
        }
    }

}
