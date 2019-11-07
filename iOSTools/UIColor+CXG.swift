//
//  UIColor+CXG.swift
//
//  Created by CuiXg on 2018/6/4.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIColor {

    /// 利用 RGB 进行设置颜色
    /// - Parameter rgb: 色值 (255, 255, 255)
    /// - Parameter alpha: 透明度
    convenience init(rgb:(R: CGFloat, G: CGFloat, B: CGFloat), alpha: CGFloat = 1) {
        if #available(iOS 10.0, *){
            self.init(displayP3Red: rgb.R / 255.0, green: rgb.G / 255.0, blue: rgb.B / 255.0, alpha: alpha)
        }else {
            self.init(red: rgb.R / 255.0, green: rgb.G / 255.0, blue: rgb.B / 255.0, alpha: alpha)
        }
    }
   
    
    /// 设置16进制色值
    ///
    /// - Parameters:
    ///   - hex: 16进制色值 例如:0xFFFFFF
    ///   - alpha: 透明度
    /// - Returns: 色值对应颜色
    convenience init(hex: NSInteger, alpha: CGFloat = 1) {
        if #available(iOS 10.0, *){
            self.init(displayP3Red: ((CGFloat)((hex & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hex & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hex & 0xFF))/255.0, alpha: alpha)
        }else {
            self.init(red: ((CGFloat)((hex & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hex & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hex & 0xFF))/255.0, alpha: alpha)
        }
    }
    

    
    /// 设置16进制色值
    /// - Parameter hexString: 16 进制色值 #FFFFFF
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    /// 将当前颜色转化为 16 进制
    func cxg_hexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
}

