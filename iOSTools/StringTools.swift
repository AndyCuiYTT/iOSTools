//
//  StringTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit


extension String {
    
    var ytt: YTTString {
        return YTTString(self)
    }
    
}

class YTTString {
    
    var string: String
    
    init(_ string: String) {
        self.string = string
    }
    
    
    
    /// 数据校验
    ///
    /// - Parameter regexStr: 正则表达式
    /// - Returns: 校验结果
    func validation(_ regexStr: String) -> Bool {
        let predicate = NSPredicate(format: "SELE MATCHES %@", regexStr)
        return predicate.evaluate(with: string)
    }
   
    /// 正则表达式获取目的值
    ///
    /// - Parameter regexStr: 正则表达式
    /// - Returns: 获取到的字符串数组
    func regexGetSubString(_ regexStr: String) -> [String] {
        var result: [String] = []
        do {
            let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
            let results = regex.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count))
            for item in results {
                result.append((string as NSString).substring(with: item.range))
            }
        } catch {
            print("error")
        }
        return result
    }
    
    
    
}



