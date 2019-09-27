//
//  UIImageView+CXG.swift
//  iOSTools
//
//  Created by CuiXg on 2019/9/27.
//  Copyright © 2019 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIImageView {
    func cxg_loadGIF(forResource name: String, withExtension ext: String) {
        //得到GIF图片的url
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: ext) else {
            assertionFailure("get gif fileURL failed")
            return
        }
        //将GIF图片转换成对应的图片源
        guard let gifSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) else {
            assertionFailure("get gif source failed")
            return
        }
        //获取其中图片源个数，即由多少帧图片组成
        let imagesCount = CGImageSourceGetCount(gifSource);
        //定义数组存储拆分出来的图片
        var images: [UIImage] = []
        var totalDuration: TimeInterval = 0
        for i in 0 ..< imagesCount {
            //从GIF图片中取出源图片
            guard let imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, nil) else {
                break
            }
            //将图片源转换成UIimageView能使用的图片源
            let img = UIImage(cgImage: imageRef)
            images.append(img)
            totalDuration += getGIFImageDeleyTime(gifSource, index: i)
        }
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    private func getGIFImageDeleyTime(_ imageRef: CGImageSource, index: Int) -> TimeInterval {
        
        if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageRef, index, nil), let gifInfo = (imageProperties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary, let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? TimeInterval) {
            return frameDuration
        }
        return 0
    }
    
    
}
