//
//  ColorTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/6/4.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIColor {
    var ytt: YTTColor {
       return YTTColor(self)
    }
    
    /// 利用 RGB 进行设置颜色
    ///
    /// - Parameters:
    ///   - R: 色值
    ///   - G: 色值
    ///   - B: 色值
    ///   - alpha: 透明度
    /// - Returns: RGB 对应颜色
    class func initWithRGB(R: CGFloat, G: CGFloat, B: CGFloat, alpha: CGFloat? = 1) -> UIColor{
        
        if #available(iOS 10.0, *){
            return UIColor(displayP3Red: CGFloat(R / 255.0), green: G / 255.0, blue: B / 255.0, alpha: alpha!)
        }else {
            return UIColor.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: alpha!)
        }
    }
    
    /// 设置16进制色值
    ///
    /// - Parameters:
    ///   - rgbValue: 16进制色值 例如:0xFFFFFF
    ///   - alpha: 透明度
    /// - Returns: 色值对应颜色
    class func initWithHex(rgbValue: NSInteger, alpha: CGFloat? = 1) -> UIColor {
        
        if #available(iOS 10.0, *){
            return UIColor(displayP3Red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha!)
        }else {
            return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha!)
        }
    }

}



struct YTTColor {
    
    private var color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
    }
    
    
    
    
    
    
}
