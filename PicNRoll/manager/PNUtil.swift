//
//  PNUtil.swift
//  PicNRoll
//
//  Created by diana on 12/24/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

extension Date
{
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MMM/dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func timeStampString() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMMddHHmmss"
        return dateFormatter.string(from: self)
    }
}

extension String
{
    func toDate() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MMM/dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return dateFormatter.date(from: self)!
    }
}



