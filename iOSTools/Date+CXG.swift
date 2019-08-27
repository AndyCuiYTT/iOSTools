//
//  SDate+CXG.swift
//
//  Created by CuiXg on 2019/8/16.
//  Copyright © 2019 AndyCuiYTT. All rights reserved.
//

import UIKit

extension Date {
    
    /// 年月日转 Date
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    /// - Returns: 对应的 Date
    static func cxg_initWith(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        let calendar = Calendar.current
        return calendar.date(from: components)
    }
    
    /// 获取当前月的天数
    ///
    /// - Returns: 本月天数
    func cxg_numberOfDaysInMonth() -> Int? {
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .month, for: self)?.count
    }
    
    /// 获取当前月第一天是周几
    ///
    /// - Returns: 1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    func cxg_weekDayOfFirstDayInMonth() -> Int? {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        guard let firstDayOfMonth = calendar.date(from: components) else { return nil }
        return calendar.ordinality(of: .weekday, in: .month, for: firstDayOfMonth)
    }
    
    /// 当前时间格式化
    ///
    /// - Parameter dateFormat: 时间格式
    /// - Returns: 格式化后时间
    func cxg_toDateFormatString(_ dateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}
