//
//  PNNotification.swift
//  PicNRoll
//
//  Created by diana on 1/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PNNotification {
    
    var id: String = ""
    var kind: Int = 0
    var vendorId: String = ""
    var vendorName:String = ""
    var folderId:String  = ""
    var folderName: String = ""
    var groupId: String = ""
    var groupName: String = ""
    var createdDate: Date = Date()
    var vendorImageUrl: String = ""
    
    func setValues(pnGroup:PNGroup){
        self.id = pnGroup.id
        self.kind = PNGlobal.GROUP
        self.vendorId = pnGroup.vendorId
        self.vendorName = pnGroup.vendorName
        self.createdDate = pnGroup.createdDate
        self.vendorImageUrl = pnGroup.groupImageUrl
    }

    func setValues(pnFolder:PNFolder){
        self.id = pnFolder.id
        self.kind = PNGlobal.FOLDER
        self.vendorId = pnFolder.vendorId
        self.vendorName = pnFolder.vendorName
        self.createdDate = pnFolder.createdDate
        self.vendorImageUrl = pnFolder.vendorProfileImageUrl
    }

}
