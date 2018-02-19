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
    let PHOTOFILETABLE = "Files"
    let GROUPTABLE = "Groups"
    let GROUPMEMBERTABLE = "GroupMembers"
    let SHAREDUSERTABLE = "SharedUsers"

    var storageRef: StorageReference = Storage.storage().reference()
    var databaseRef: DatabaseReference = Database.database().reference()
    var auth = Auth.auth()
    var deviceToken: String = ""
    
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
                            "deviceToken": Messaging.messaging().fcmToken,
                            "lat":lat,
                            "lng":lng,
                            "profileImageUrl":""] as! [AnyHashable : String]
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
    
    func updateUser(pnUser:PNUser,
                    completion: @escaping (Error?) -> Swift.Void){
        let post = ["Email": pnUser.email,
                    "Name": pnUser.name,
                    "PhoneNumber":pnUser.phoneNumber ,
                    "deviceToken": self.deviceToken,
                    "lat":pnUser.lat,
                    "lng":pnUser.lng,
                    "profileImageUrl":""] as [AnyHashable : String]
        self.databaseRef.child("Users").child((pnUser.id)).updateChildValues(post)
        completion(nil)
    }
    
    func updateUserEmail(email:String,completion: @escaping (Error?) -> Swift.Void){
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            completion(error)
        }
    }
    
    func updateUserProfile(image : UIImage,
                           completion: @escaping (String?,Error?) -> Swift.Void){
        let photoId = getRamdomID() as String?
        let userId = getCurrentUserID() as String?

        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let riversRef = storageRef.child("Files/"+userId!+"/profile/"+photoId!+".jpg")
        riversRef.putData(imageData!, metadata: nil) { (metadata, error) in
            var urlString: String = ""
            if error == nil{
                let downloadURL = metadata?.downloadURL()
                urlString = (downloadURL?.absoluteString)!
                let post = ["profileImageUrl":urlString] as [AnyHashable : AnyObject]
                self.databaseRef.child("Users").child(userId!).updateChildValues(post)
            }
            completion(urlString,error)
        }
    }

    func signInUser(email:String,
                  password:String,
                  completion: @escaping (PNUser?,Error?) -> Swift.Void){
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.getUserInformation(userId: (user?.uid)!, completion: {(pnUser: PNUser?,error: Error?) in
                    pnUser?.id = (user?.uid)!
                    self.updateUserDeviceToken(pnUser!)
                    completion(pnUser,error)
                })
            }else{
                completion(nil,error)
            }
        }
    }
    
    func updateUserDeviceToken(_ pnUser:PNUser){
        self.databaseRef.child("Users").child((pnUser.id)).child("deviceToken").setValue(Messaging.messaging().fcmToken)
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
            let userId = snapshot.key
            let value = snapshot.value as? NSDictionary
            pnUser.setValuesWithSnapShot(id:userId,value: value!)
            completion(pnUser,nil)
        }) { (error) in
            completion(nil,error)
        }
    }
    
    func createFolder(folder:PNFolder,completion: @escaping () -> Swift.Void){
        let post = ["id": folder.id,
                    "name": folder.name,
                    "vendorId": folder.vendorId,
                    "vendorName": folder.vendorName,
                    "vendorProfileImageUrl": folder.vendorProfileImageUrl,
                    "createdDate": folder.createdDate.toString(),
                    "isShare": folder.isShare,
                    "isView":folder.isView,
                    "canAddPicture": true,
                    "firstImageUrl":""] as [AnyHashable : AnyObject]
        self.databaseRef.child(ALBUMTABLE).child(getCurrentUserID()!).child(folder.id).setValue(post)
        completion()
    }
    
    func deleteFolder(folder:PNFolder,completion: @escaping () -> Swift.Void){
        self.databaseRef.child(ALBUMTABLE).child(getCurrentUserID()!).child(folder.id).removeValue()
        completion()
    }
    
    func setImageUrlofFolder(folderId:String,
                             vendorId:String,
                             url:String,
                             completion: @escaping () -> Swift.Void){
        self.databaseRef.child(ALBUMTABLE).child(vendorId).child(folderId).child("firstImageUrl").setValue(url)
        completion()
    }
    
    func getFolders(completion: @escaping ([PNFolder]?,Error?) -> Swift.Void){
        self.databaseRef.child(ALBUMTABLE).child(getCurrentUserID()!).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    func addPicture(folderID:String,
                    image : UIImage,
                    completion: @escaping (String?,Error?) -> Swift.Void){
        let photoId = getRamdomID() as String?
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let riversRef = storageRef.child("Files/"+getCurrentUserID()!+"/"+photoId!+".jpg")
        riversRef.putData(imageData!, metadata: nil) { (metadata, error) in
            var urlString: String = ""
            if error == nil{
                let downloadURL = metadata?.downloadURL()
                urlString = (downloadURL?.absoluteString)!
                let post = ["id": photoId!,
                            "name": "",
                            "vendorId": self.getCurrentUserID()!,
                            "vendorName": PNGlobal.CURRENT_USER_NAME,
                            "createdDate": Date().toString(),
                            "imageUrl":urlString] as [AnyHashable : String]
                self.databaseRef.child(self.PHOTOFILETABLE).child(folderID).child(photoId!).setValue(post)
            }
            completion(urlString,error)
        }
    }
    
    func getPictures(folderID:String,
                    completion: @escaping ([PNPhoto]?,Error?) -> Swift.Void){
        self.databaseRef.child(PHOTOFILETABLE).child(folderID).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    func createGroup(groupName:String,
                      completion: @escaping () -> Swift.Void){
        let groupId = getRamdomID() as String?
        let post = ["id": groupId ?? "",
                    "name": groupName,
                    "vendorId": getCurrentUserID()!,
                    "vendorName": PNGlobal.CURRENT_USER_NAME,
                    "canShowGroupMember": true,
                    "isView": false,
                    "createdDate": Date().toString()] as [AnyHashable : Any]
        self.databaseRef.child(GROUPTABLE).child(getCurrentUserID()!).child(groupId!).setValue(post)
        completion()
    }
    
    func deleteGroup(pnGroup:PNGroup,
                     completion: @escaping () -> Swift.Void){
        self.databaseRef.child(GROUPTABLE).child(getCurrentUserID()!).child(pnGroup.id).removeValue()
        completion()
    }

    func getGroups(completion: @escaping ([PNGroup]?,Error?) -> Swift.Void){
        self.databaseRef.child(GROUPTABLE).child(getCurrentUserID()!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                let userId = snapshot.key as String
                let value = snapshot.value as? NSDictionary
                pnUser.setValuesWithSnapShot(id:userId,value: value!)
                usersArr.append(pnUser)
            }
            completion(usersArr)
        })
    }
    
    func addMembers(pnGroup:PNGroup,
                    groupMemberList: [PNUser],
                    friendList: [PNUser],
                    contactList: [PNUser],
                    completion: @escaping () -> Swift.Void){
        for pnUser in friendList{
            
            if pnUser.isInLists(userLists: groupMemberList) == false{
                let post = ["id": pnUser.id,
                            "name": pnUser.name,
                            "Email": pnUser.email,
                            "PhoneNumber":pnUser.phoneNumber ,
                            "profileImageUrl":pnUser.profileImageUrl,
                            "isInvite":false] as [AnyHashable : AnyObject]
                self.databaseRef.child(GROUPMEMBERTABLE).child(pnGroup.id).childByAutoId().setValue(post)
                self.addGrouptoUsers(pnUser: pnUser, pnGroup: pnGroup)
            }
        }
        
        for pnUser in contactList{
            if pnUser.isInLists(userLists: groupMemberList) == false{
                let post = ["id": pnUser.id,
                            "name": pnUser.name,
                            "Email": pnUser.email,
                            "PhoneNumber":pnUser.phoneNumber ,
                            "profileImageUrl":"",
                            "isInvite":true] as [AnyHashable : AnyObject]
                self.databaseRef.child(GROUPMEMBERTABLE).child(pnGroup.id).childByAutoId().setValue(post)
            }
        }
        completion()
    }
    
    func addGrouptoUsers(pnUser:PNUser,pnGroup:PNGroup){
        let post = ["id": pnGroup.id,
                    "name": pnGroup.name,
                    "vendorId": pnGroup.vendorId,
                    "vendorName": pnGroup.vendorName,
                    "canShowGroupMember": true,
                    "createdDate": pnGroup.createdDate.toString()] as [AnyHashable : AnyObject]
        self.databaseRef.child(GROUPTABLE).child(pnUser.id).child(pnGroup.id).setValue(post)
    }
    
    func getGroupMembers(groupId:String,
                         completion: @escaping ([PNUser]) -> Swift.Void){
        databaseRef.child(GROUPMEMBERTABLE).child(groupId).observeSingleEvent(of: .value, with: {snapshot in
            var usersArr: [PNUser] = []
            for snapshot in snapshot.children.allObjects as! [DataSnapshot]{
                let pnUser = PNUser()
                let value = snapshot.value as? NSDictionary
                pnUser.id = value!["id"] as? String ?? ""
                pnUser.name = value!["name"] as? String ?? ""
                pnUser.email = value!["Email"] as? String ?? ""
                pnUser.phoneNumber = value!["PhoneNumber"] as? String ?? ""
                pnUser.isInvite = value!["isInvite"] as? Bool ?? false
                pnUser.profileImageUrl = value!["profileImageUrl"] as? String ?? ""
                usersArr.append(pnUser)
            }
            completion(usersArr)
        })
    }
    
    func addSharedUserForFolder(pnFoder:PNFolder,
                    friendList: [PNUser],
                    contactList: [PNUser],
                    completion: @escaping () -> Swift.Void){
        for pnUser in friendList{
            let post = ["id": pnUser.id,
                        "name": pnUser.name,
                        "profileImageUrl":pnUser.profileImageUrl,
                        "isInvite":false] as [AnyHashable : AnyObject]
            self.databaseRef.child(SHAREDUSERTABLE).child(pnFoder.id).childByAutoId().setValue(post)
            self.addFoldertoUsers(pnUser: pnUser, pnFolder: pnFoder)
        }
        
        for pnUser in contactList{
            let post = ["id": pnUser.id,
                        "name": pnUser.name,
                        "profileImageUrl":"",
                        "isInvite":true] as [AnyHashable : AnyObject]
            self.databaseRef.child(SHAREDUSERTABLE).child(pnFoder.id).childByAutoId().setValue(post)
        }
        completion()
    }
    
    func addFoldertoUsers(pnUser:PNUser,pnFolder:PNFolder){
        let post = ["id": pnFolder.id,
                    "name": pnFolder.name,
                    "vendorId": pnFolder.vendorId,
                    "vendorName": pnFolder.vendorName,
                    "firstImageUrl": pnFolder.firstImageUrl,
                    "isShare": true,
                    "canAddPicture": true,
                    "createdDate": pnFolder.createdDate.toString()] as [AnyHashable : AnyObject]
        self.databaseRef.child(ALBUMTABLE).child(pnUser.id).child(pnFolder.id).setValue(post)
    }

    func SignOut(){
        try! Auth.auth().signOut()
    }
    
    func sendNotification(title: String, message: String, userToken: String,completion: @escaping (String?) -> Swift.Void) {
        if Platform.isSimulator == false {
                //        if userToken != nil {
                var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.setValue("key=AAAARbUrX2Y:APA91bG5Ue4xkeEhv_MnhW5y8jGgxAuZXuKsVn5WbNGuGdNJPCOV9euduBONeo75qzvV8cCuKAYKr6pgOA7Fxkc3l-rdILSS0ZcF9dxtaIKwQgKoC6dxd2wnAGCYwGT9BesJKJhcdnF9", forHTTPHeaderField: "Authorization")
                request.setValue("key=AAAAAmwdLUI:APA91bFOnUWq-HSKwZU7w3n0v0la-g2n398WRKmEnf-7yfXbcgbO5FGN8jZuMZeChU1Jk_dvSjFZq5kR_hEkTQje74SZMwcm7cTOWRzgJC2AWVBgzWeRrY_T6j_28Qpnnb3XFBjOyIF6", forHTTPHeaderField: "Authorization")
                let json = [
                    "to" : userToken,
                    "priority" : "high",
                    "notification" : [
                        "title" : title,
                        "body"  : message,
                        "badge" : 1
                    ]
                    ] as [String : Any]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    request.httpBody = jsonData
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error=\(String(describing: error))")
                            return
                        }
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                            completion("Status Code should be 200, but is \(httpStatus.statusCode)")
                        }
                        let responseString = String(data: data, encoding: .utf8)
                        completion(responseString)
                    }
                    task.resume()
                }
                catch {
                    completion(error.localizedDescription)
                }
        }else{
            completion("can't send push nofication on simulator")
        }
    }

//    func getUserFriendIds(block: @escaping ([String]) -> Swift.Void) {
//        guard let userId = getCurrentUserID() else {return}
//        var ids: [String] = []
//        databaseRef.child(USERTABLE).child(userId).child("friends").observeSingleEvent(of: .value, with: { friends in
//            if let friendsJson = friends.value as? NSDictionary {
//                for (key, _) in friendsJson {
//                    ids.append(key as! String)
//                }
//            }
//            block(ids)
//        })
//    }
//
//    func addNewFriend(friendID:String,
//                      completion: @escaping (Error?) -> Swift.Void) {
//        guard let userID = getCurrentUserID() else { return }
//        databaseRef.child(USERTABLE).child(userID).child("friends").child(friendID).setValue(true) { error, ref in
//            if error != nil {
//                self.databaseRef.child(self.USERTABLE).child(friendID).child("friends").child(userID).setValue(true) { error, ref in
//                    completion(error)
//                }
//            }else{
//                completion(error)
//            }
//        }
//    }

}
