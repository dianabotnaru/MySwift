//
//  PNFolder.swift
//  PicNRoll
//
//  Created by jordi on 15/12/2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNFolder{

    var id: String = ""
    var name: String = ""
    var vendorId: String = ""
    var vendorName: String = ""
    var firstImageUrl : String = ""
    var createdDate: Date = Date()
    var isShare: Bool = false
    
    func setValues(id:String,name:String,vendorId:String,vendorName:String,firstImageUrl:String,createdDate:Date,isShare:Bool){
        self.id = id
        self.name = name
        self.vendorId = vendorId
        self.vendorName = vendorName
        self.firstImageUrl = firstImageUrl
        self.createdDate = createdDate
        self.isShare = isShare
    }
}
