//
//  UImage+CXG.swift
//
//  Created by CuiXg on 2018/4/3.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 截取视图
    ///
    /// - Parameters:
    ///   - currentView: 要截取的视图
    ///   - size: 将来创建出来的bitmap的大小
    ///   - opaque: 设置透明YES代表透明，NO代表不透明
    ///   - scale: 代表缩放,0代表不缩放
    /// - Returns: 要截取视图对应的 UIImage 对象
    class func cxg_captureScreen(currentView: UIView, opaque: Bool, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, opaque, scale)
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// 根据颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    class func cxg_initWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// base64 转 UIImage
    ///
    /// - Parameter base64: 图片base64
    class func cxg_initWithBase64(_ base64: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    /// 通过 URL 加载图片
    ///
    /// - Parameter urlStr: 图片 URL 地址
    class func cxg_initWithURL(_ urlStr: String) -> UIImage? {
        
        if let url = URL(string: urlStr) {
            do {
                let imageData = try Data(contentsOf: url, options: .mappedIfSafe)
                return UIImage(data: imageData)
            }catch {
                return nil
            }
        }
        return nil
    }
    

    
    /// 获取圆形图片
    ///
    /// - Returns: 圆形图片
    func cxg_circleImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        context?.clip()
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 修改图片 size
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 修改后的图片
    func cxg_resetImageSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据宽度重新绘制图片
    ///
    /// - Parameter width: 所需宽度
    /// - Returns: 所需尺寸图片
    func cxg_resetImageSizeWithWidth(_ width: CGFloat) -> UIImage? {
        let height = self.size.height * (width / self.size.width)
        return cxg_resetImageSize(CGSize(width: width, height: height))
    }
    
    /// 根据高度重新绘制图片
    ///
    /// - Parameter height: 所需高度
    /// - Returns: 所需尺寸图片
    func cxg_resetImageSizeWithHeight(_ height: CGFloat) -> UIImage? {
        let width = self.size.width * (height / self.size.height)
        return cxg_resetImageSize(CGSize(width: width, height: height))
    }
    
    /// 根据比例重新绘制图片
    ///
    /// - Parameter scale: 所需比例
    /// - Returns: 所需尺寸图片
    func cxg_resetImageSizeWithScale(_ scale: CGFloat) -> UIImage? {
        return cxg_resetImageSize(CGSize(width: self.size.width * scale, height: self.size.height * scale))
    }
    
    /// 为图片添加图片遮罩
    ///
    /// - Parameters:
    ///   - maskImage: 遮罩图片
    ///   - maskRect: 遮罩层位置,大小
    /// - Returns: 添加遮罩图片
    func cxg_addMaskLayler(maskImage: UIImage, maskRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        maskImage.draw(in: maskRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 图片转 base64
    ///
    /// - Returns: 图片 base64值
    func cxg_toBase64() -> String? {
        let imageData = UIImagePNGRepresentation(self)
        return imageData?.base64EncodedString(options: .lineLength64Characters)
    }

    /// 保存当前图片到相册(需要添加权限)
    func cxg_saveToPhotosAlbum() {
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        let alertVC = UIAlertController(title: "系统提示", message: nil, preferredStyle: .alert)
        
        if error != nil {
            alertVC.message = "图片保存失败!"
        }else {
            alertVC.message = "图片保存成功!"
        }
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//                alertVC.dismiss(animated: true, completion: nil)
//            })
        })
    }
    
    /// 获取图片触摸点颜色
    ///
    /// 参考资料
    /// https://www.cnblogs.com/Free-Thinker/p/5946719.html
    /// https://www.hangge.com/blog/cache/detail_2304.html
    /// - Parameters:
    ///   - image: 要获取颜色的图片
    ///   - point: 触摸点
    /// - Returns: 获取到的颜色
    func cxg_getPointColor(point: CGPoint) -> UIColor? {
        guard CGRect(origin: CGPoint(x: 0, y: 0), size: self.size).contains(point) else {
            return nil
        }
        
        let pointX = trunc(point.x);
        let pointY = trunc(point.y);
        
        let width = self.size.width;
        let height = self.size.height;
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        
        pixelData.withUnsafeMutableBytes { pointer in
            if  let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = self.cgImage {
                context.setBlendMode(.copy)
                context.translateBy(x: -pointX, y: pointY - height)
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

