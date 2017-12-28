//
//  PNGroup.swift
//  PicNRoll
//
//  Created by diana on 12/26/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNGroup{

    var id: String = ""
    var name: String = ""
    var vendorId: String = ""
    var vendorName: String = ""
    var canShowGroupMemeber:Bool = false
    var createdDate: Date = Date()
    
    func setValues(id:String,name:String,vendorId:String,vendorName:String,createdDate:Date){
        self.id = id
        self.name = name
        self.vendorId = vendorId
        self.vendorName = vendorName
        self.createdDate = createdDate
    }
    
    func setValuesWithSnapShot(value : NSDictionary){
        self.id = value["id"] as? String ?? ""
        self.name = value["name"] as? String ?? ""
        self.vendorId = value["vendorId"] as? String ?? ""
        self.vendorName = value["vendorName"] as? String ?? ""
        self.canShowGroupMemeber = value["canShowGroupMember"] as? Bool ?? false
        let dateString = value["createdDate"] as? String ?? ""
        self.createdDate = dateString.toDate()
    }
    
}
