//
//  PNUser.swift
//  PicNRoll
//
//  Created by Diana on 19/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNUser{
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var deviceToken: String = ""
    var lat: String = ""
    var lng: String = ""
    var profileImageUrl: String = ""    
    
    
    func setValues(id:String,name:String,email:String,phoneNumber:String,lat:String,lng:String,profileImageUrl:String){
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.lat = lat
        self.lng = lng
        self.profileImageUrl = profileImageUrl
    }
    
    func setValuesWithSnapShot(value : NSDictionary){
        self.name = value["Name"] as? String ?? ""
        self.email = value["Email"] as? String ?? ""
        self.phoneNumber = value["PhoneNumber"] as? String ?? ""
        self.deviceToken = value["deviceToken"] as? String ?? ""
        self.lat = value["lat"] as? String ?? ""
        self.lng = value["lng"] as? String ?? ""
        self.profileImageUrl = value["profileImageUrl"] as? String ?? ""
    }
}
