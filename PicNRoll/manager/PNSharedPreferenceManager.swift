//
//  PNSharedPreferenceManager.swift
//  PicNRoll
//
//  Created by new on 1/16/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PNSharedPreferenceManager {
    
    static let shared = PNSharedPreferenceManager()
    
    let ID_KEY = "id"
    let NAME_KEY = "name"
    let IMAGE_URL_KEY = "profileImageUrl"

    func saveUserName(name: String){
        let preferences = UserDefaults.standard
        preferences.set(name, forKey: NAME_KEY)
    }
    
    func saveProfileImageUrl(profileImageUrl: String){
        let preferences = UserDefaults.standard
        preferences.set(profileImageUrl, forKey: IMAGE_URL_KEY)
    }

    
    func getUserName() -> String{
        let preferences = UserDefaults.standard
        if preferences.object(forKey: NAME_KEY) == nil{
            return ""
        }else{
            let userName = preferences.object(forKey: NAME_KEY) as! String
            return userName
        }
    }
    
    func getProfileImageUrl() -> String{
        let preferences = UserDefaults.standard
        if preferences.object(forKey: IMAGE_URL_KEY) == nil{
            return ""
        }else{
            let imageUrl = preferences.object(forKey: IMAGE_URL_KEY) as! String
            return imageUrl
        }
    }
}
