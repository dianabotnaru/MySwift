//
//  PNPicture.swift
//  PicNRoll
//
//  Created by diana on 12/26/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class PNPhoto {
    
    var id: String = ""
    var name: String = ""
    var vendorId: String = ""
    var vendorName: String = ""
    var imageUrl : String = ""
    var createdDate: Date = Date()
    
    func setValuesWithSnapShot(value : NSDictionary){
        self.id = value["id"] as? String ?? ""
        self.name = value["name"] as? String ?? ""
        self.vendorId = value["vendorId"] as? String ?? ""
        self.vendorName = value["vendorName"] as? String ?? ""
        let dateString = value["createdDate"] as? String ?? ""
        self.createdDate = dateString.toDate()
        self.imageUrl = value["imageUrl"] as? String ?? ""
    }
}
