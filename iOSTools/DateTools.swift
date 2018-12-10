//
//  DateTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/6/4.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension Date {
    var ytt: YTTDate {
        return YTTDate(self)
    }
    
    
    static func initWithDateString(dateStr: String, formatter: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: dateStr)
    }
    
    
    
    
}




struct YTTDate {

    private var date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    
    func toString(_ formatter: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
    
    
    
}
