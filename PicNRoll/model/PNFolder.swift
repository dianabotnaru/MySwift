//
//  PNFolder.swift
//  PicNRoll
//
//  Created by diana on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNFolder{

    var id: String = ""
    var name: String = ""
    var vendorId: String = ""
    var vendorName: String = ""
    var vendorProfileImageUrl : String = ""
    var firstImageUrl : String = ""
    var createdDate: Date = Date()
    var isShare: Bool = false
    var canAddPicture : Bool = false
    
    func setValues(id:String,name:String,vendorId:String,vendorName:String,vendorProfileImageUrl:String,firstImageUrl:String,createdDate:Date,isShare:Bool){
        self.id = id
        self.name = name
        self.vendorId = vendorId
        self.vendorName = vendorName
        self.vendorProfileImageUrl = vendorProfileImageUrl
        self.firstImageUrl = firstImageUrl
        self.createdDate = createdDate
        self.isShare = isShare
    }
    
    func setValuesWithSnapShot(value : NSDictionary){
        self.id = value["id"] as? String ?? ""
        self.name = value["name"] as? String ?? ""
        self.vendorId = value["vendorId"] as? String ?? ""
        self.vendorName = value["vendorName"] as? String ?? ""
        self.firstImageUrl = value["firstImageUrl"] as? String ?? ""
        self.vendorProfileImageUrl = value["vendorProfileImageUrl"] as? String ?? ""
        let dateString = value["createdDate"] as? String ?? ""
        self.createdDate = dateString.toDate()
        self.isShare = value["isShare"] as? Bool ?? false
        self.canAddPicture = value["canAddPicture"] as? Bool ?? false
    }

}
