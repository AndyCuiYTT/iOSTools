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
    /// - Returns: 要截取视图对应的 UIImage 对象
    @available(iOS 10.0, *)
    convenience init?(currentView: UIView) {
        let renderer = UIGraphicsImageRenderer(size: currentView.bounds.size)
        let pngData = renderer.pngData { (context) in
            currentView.layer.render(in: context.cgContext)
        }
        self.init(data: pngData)
    }
    
    /// 截取视图
    ///
    /// - Parameters:
    ///   - currentView: 要截取的视图
    /// - Returns: 要截取视图对应的 UIImage 对象
    class func cxg_captureScreen(currentView: UIView) -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: currentView.bounds.size)
            return renderer.image { (context) in
                currentView.layer.render(in: context.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, false, UIScreen.main.scale)
            currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    
    /// 根据颜色生成图片
    /// - Parameter color: 图片颜色
    /// - Parameter size: 图片尺寸
    @available(iOS 10.0, *)
    convenience init?(color: UIColor, size: CGSize) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let pngData = renderer.pngData { (context) in
            let context = context.cgContext
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        }
        self.init(data: pngData)
    }
    
    
    /// 根据颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    class func cxg_init(withColor color: UIColor, size: CGSize) -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                let context = context.cgContext
                context.setFillColor(color.cgColor)
                context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
            }
        } else {
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    
    /// base64 转 UIImage
    ///
    /// - Parameter base64: 图片base64
    convenience init?(base64: String) {
        guard let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            self.init()
            return
        }
        self.init(data: imageData)
    }

    /// 通过 URL 加载图片
    ///
    /// - Parameter urlStr: 图片 URL 地址
    convenience init?(urlStr: String) {
        if let url = URL(string: urlStr) {
            do {
                let imageData = try Data(contentsOf: url, options: .mappedIfSafe)
                self.init(data: imageData)
            }catch {}
        }
        self.init()
    }
    
    
    /// 获取圆形图片
    ///
    /// - Returns: 圆形图片
    func cxg_circle() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                let context = context.cgContext
                context.addEllipse(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
                context.clip()
                self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            context?.addEllipse(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
            context?.clip()
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
    }

    /// 获取圆角图片
    /// - Parameter radius: 圆角半径
    func xfs_cornerRadius(_ radius: CGFloat) -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                let context = context.cgContext
                context.addPath(UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size), cornerRadius: radius).cgPath)
                context.clip()
                self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            context?.addPath(UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size), cornerRadius: radius).cgPath)
            context?.clip()
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
    }
    
    /// 修改图片 size
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 修改后的图片
    func cxg_reset(withSize size: CGSize) -> UIImage? {
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
    }
    
    /// 根据宽度重新绘制图片
    ///
    /// - Parameter width: 所需宽度
    /// - Returns: 所需尺寸图片
    func cxg_reset(withWidth width: CGFloat) -> UIImage? {
        let height = self.size.height * (width / self.size.width)
        return cxg_reset(withSize: CGSize(width: width, height: height))
    }
    
    /// 根据高度重新绘制图片
    ///
    /// - Parameter height: 所需高度
    /// - Returns: 所需尺寸图片
    func cxg_reset(withHeight height: CGFloat) -> UIImage? {
        let width = self.size.width * (height / self.size.height)
        return cxg_reset(withSize: CGSize(width: width, height: height))
    }
    
    /// 根据比例重新绘制图片
    ///
    /// - Parameter scale: 所需比例
    /// - Returns: 所需尺寸图片
    func cxg_reset(withScale scale: CGFloat) -> UIImage? {
        return cxg_reset(withSize: CGSize(width: self.size.width * scale, height: self.size.height * scale))
    }
    
    /// 为图片添加图片遮罩
    ///
    /// - Parameters:
    ///   - maskImage: 遮罩图片
    ///   - maskRect: 遮罩层位置,大小
    /// - Returns: 添加遮罩图片
    func cxg_add(maskImage: UIImage?, maskRect: CGRect) -> UIImage? {
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                maskImage?.draw(in: maskRect)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            maskImage?.draw(in: maskRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
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
    func cxg_pointColor(point: CGPoint) -> UIColor? {
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

extension UIImage {

    public class func cxg_gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            assertionFailure("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func cxg_gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            assertionFailure("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            assertionFailure("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return cxg_gif(data: imageData)
    }

    public class func cxg_gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            assertionFailure("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            assertionFailure("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return cxg_gif(data: imageData)
    }

    @available(iOS 9.0, *)
    public class func cxg_gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            assertionFailure("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return cxg_gif(data: dataAsset.data)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}

// MARK: 二维码生成
extension UIImage {
    class func xfs_QRCode(contentInfo: String, size: CGSize, backgroudColor: UIColor = UIColor.white, foregroundColor: UIColor = UIColor.black) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }

        filter.setDefaults()
        // 容错率
        filter.setValue("L", forKey: "inputCorrectionLevel")
        filter.setValue(contentInfo.data(using: .utf8), forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }

        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        // 前景色
        colorFilter?.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        // 背景色
        colorFilter?.setValue(CIColor(color: backgroudColor), forKey: "inputColor1")

        let scale = min(size.width / ciImage.extent.width, size.height / ciImage.extent.height)
        if #available(iOS 10.0, *) {
            if let transFormImage = colorFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale), highQualityDownsample: true) {
                return UIImage(ciImage: transFormImage)
            }else {
                return UIImage(ciImage: ciImage)
            }

        } else {
            if let transFormImage = colorFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale)) {
                return UIImage(ciImage: transFormImage)
            }else {
                return UIImage(ciImage: ciImage)
            }
        }
    }
}



