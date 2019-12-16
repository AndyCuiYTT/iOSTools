//
//  YTTCustomButton.swift
//  iOSTools
//
//  Created by AndyCui on 2018/7/12.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

/// 图片位置
///
/// - top: 图片在上
/// - right: 图片在右
/// - left: 图片在左
/// - bottom: 图片在下
enum YTTButtonImageAlignment {
    
    /// 图片在上
    case top
    
    /// 图片在下
    case bottom
    
    /// 图片在右
    case right
    
    /// 图片在左
    case left
}


class YTTCustomButton: UIButton {
    
    
    ///  按钮中图片的位置
    var imageAlignment: YTTButtonImageAlignment = .left
    
    
    /// 按钮中图片与文字的间距
    var spaceBetweenTitleAndImage: CGFloat = 5
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleLabel = self.titleLabel, let imageView = self.imageView {

            let space = spaceBetweenTitleAndImage

            let imageSize = imageView.bounds.size
            let labelSize = ((titleLabel.text ?? "") as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: titleLabel.font], context: nil).size

            switch imageAlignment {
            case .top:
                let marginY = (bounds.height - (imageSize.height + labelSize.height + space)) / 2
                let imageViewX = (bounds.width - imageSize.width) / 2
                let labelX = (bounds.width - labelSize.width) / 2
                let labelY = marginY + imageSize.height + space
                imageView.frame = CGRect(origin: CGPoint(x: imageViewX, y: marginY), size: imageSize)
                titleLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: labelSize)
            case .right:
                let marginX = (bounds.width - (imageSize.width + labelSize.width + space)) / 2
                let imageViewY = (bounds.height - imageSize.height) / 2
                let labelY = (bounds.height - labelSize.height) / 2
                let imageViewX = marginX + labelSize.width + space
                imageView.frame = CGRect(origin: CGPoint(x: imageViewX, y: imageViewY), size: imageSize)
                titleLabel.frame = CGRect(origin: CGPoint(x: marginX, y: labelY), size: labelSize)
            case .left:
                let marginX = (bounds.width - (imageSize.width + labelSize.width + space)) / 2
                let imageViewY = (bounds.height - imageSize.height) / 2
                let labelY = (bounds.height - labelSize.height) / 2
                let labelX = marginX + imageSize.width + space
                imageView.frame = CGRect(origin: CGPoint(x: marginX, y: imageViewY), size: imageSize)
                titleLabel.frame = CGRect(origin: CGPoint(x: labelX, y: labelY), size: labelSize)

            case .bottom:
                let marginY = (bounds.height - (imageSize.height + labelSize.height + space)) / 2
                let imageViewX = (bounds.width - imageSize.width) / 2
                let labelX = (bounds.width - labelSize.width) / 2
                let imageViewY = marginY + labelSize.height + space
                titleLabel.frame = CGRect(origin: CGPoint(x: imageViewX, y: marginY), size: imageSize)
                imageView.frame = CGRect(origin: CGPoint(x: labelX, y: imageViewY), size: labelSize)
            }
        }
        
    }
    
    
}
