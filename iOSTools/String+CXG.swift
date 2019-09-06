//
//  String+CXG.swift
//
//  Created by CuiXg on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit


extension String {
    
  
    /// 数据校验
    ///
    /// - Parameter regexStr: 正则表达式
    /// - Returns: 校验结果
    func cxg_validation(_ regexStr: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexStr)
        return predicate.evaluate(with: self)
    }
   
    /// 正则表达式获取目的值
    ///
    /// - Parameter regexStr: 正则表达式
    /// - Returns: 获取到的字符串数组
    func cxg_regexGetSubString(_ regexStr: String) -> [String] {
        var result: [String] = []
        do {
            let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
            let results = regex.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))
            for item in results {
                result.append((self as NSString).substring(with: item.range))
            }
        } catch {
            print("error")
        }
        return result
    }
    
    
    
}



