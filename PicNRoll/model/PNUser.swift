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
    var lat: String = ""
    var lng: String = ""
    var profileImageUrl: String = ""    
    
    init(id:String,name:String,email:String,phoneNumber:String,lat:String,lng:String,profileImageUrl:String){
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.lat = lat
        self.lng = lng
        self.profileImageUrl = profileImageUrl
    }
}
