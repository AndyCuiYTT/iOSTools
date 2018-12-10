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
            
            let titleLabelWidth = titleLabel.bounds.width
            let titleLabelHeight = titleLabel.bounds.height
            
            let imageViewWidth = imageView.bounds.width
            let imageViewHeight = imageView.bounds.height
            
            // self.center.x 用此方法获取按钮中心点 X 造成死循环
            
            let btnCenterX = self.bounds.width / 2 //按钮中心点X的坐标（以按钮左上角为原点的坐标系）
            let imageViewCenterX = btnCenterX - titleLabelWidth / 2 //imageView中心点X的坐标（以按钮左上角为原点的坐标系）
            let titleLabelCenterX = btnCenterX + imageViewWidth / 2 //titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）
            
            switch imageAlignment {
            case .top:
                self.titleEdgeInsets = UIEdgeInsets(top: imageViewHeight / 2 + space / 2, left: -(titleLabelCenterX - btnCenterX), bottom: -(imageViewHeight / 2 + space / 2), right: titleLabelCenterX - btnCenterX)
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleLabelHeight / 2 + space / 2), left: btnCenterX - imageViewCenterX, bottom: titleLabelHeight / 2 + space / 2, right: imageViewCenterX - btnCenterX)
            case .right:
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageViewWidth + space / 2), bottom: 0, right: imageViewWidth + space / 2)
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabelWidth + space / 2, bottom: 0, right: -(titleLabelWidth + space / 2))
            case .left:
                self.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2, bottom: 0, right: space / 2)
            case .bottom:
                self.titleEdgeInsets = UIEdgeInsets(top: -imageViewHeight / 2 - space / 2, left: -(titleLabelCenterX - btnCenterX), bottom: imageViewHeight / 2 + space / 2, right: titleLabelCenterX - btnCenterX)
                self.imageEdgeInsets = UIEdgeInsets(top: titleLabelHeight / 2 + space / 2, left: btnCenterX - imageViewCenterX, bottom: -titleLabelHeight / 2 - space / 2, right: imageViewCenterX - btnCenterX)
            }
            
        }
        
    }
    
    
}
