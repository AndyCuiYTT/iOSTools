//
//  ImageTools.swift
//  ImageDemo
//
//  Created by AndyCui on 2018/4/3.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIImage {
    
    var ytt: YTTImage {
        return YTTImage(self)
    }
        
    /// 截取视图
    ///
    /// - Parameters:
    ///   - currentView: 要截取的视图
    ///   - size: 将来创建出来的bitmap的大小
    ///   - opaque: 设置透明YES代表透明，NO代表不透明
    ///   - scale: 代表缩放,0代表不缩放
    /// - Returns: 要截取视图对应的 UIImage 对象
    static func captureScreen(currentView: UIView, opaque: Bool, scale: CGFloat) -> UIImage? {
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
    static func initWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
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
    static func initWithBase64(_ base64: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
}


class YTTImage: NSObject {
    private var image: UIImage
    init(_ image: UIImage) {
        self.image = image
    }
    
    /// 修改图片 size
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 修改后的图片
    func resetImageSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 根据宽度重新绘制图片
    ///
    /// - Parameter width: 所需宽度
    /// - Returns: 所需尺寸图片
    func resetImageSizeWithWidth(_ width: CGFloat) -> UIImage? {
        let height = image.size.height * (width / image.size.width)
        return resetImageSize(CGSize(width: width, height: height))
    }
    
    /// 根据高度重新绘制图片
    ///
    /// - Parameter height: 所需高度
    /// - Returns: 所需尺寸图片
    func resetImageSizeWithHeight(_ height: CGFloat) -> UIImage? {
        let width = image.size.width * (height / image.size.height)
        return resetImageSize(CGSize(width: width, height: height))
    }
    
    /// 根据比例重新绘制图片
    ///
    /// - Parameter scale: 所需比例
    /// - Returns: 所需尺寸图片
    func resetImageSizeWithScale(_ scale: CGFloat) -> UIImage? {
        return resetImageSize(CGSize(width: image.size.width * scale, height: image.size.height * scale))
    }
    
    /// 为图片添加图片遮罩
    ///
    /// - Parameters:
    ///   - maskImage: 遮罩图片
    ///   - maskRect: 遮罩层位置,大小
    /// - Returns: 添加遮罩图片
    func addMaskLayler(maskImage: UIImage, maskRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.image.size, true, 0)
        self.image.draw(in: CGRect(x: 0, y: 0, width: self.image.size.width, height: self.image.size.height))
        maskImage.draw(in: maskRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 图片转 base64
    ///
    /// - Returns: 图片 base64值
    func toBase64() -> String? {
        let imageData = UIImagePNGRepresentation(self.image)
        return imageData?.base64EncodedString(options: .lineLength64Characters)
    }

    /// 保存当前图片到相册(需要添加权限)
    func saveToPhotosAlbum() {
        UIImageWriteToSavedPhotosAlbum(self.image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
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
}

