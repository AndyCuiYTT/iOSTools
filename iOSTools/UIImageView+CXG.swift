//
//  UIImageView+CXG.swift
//  iOSTools
//
//  Created by CuiXg on 2019/9/27.
//  Copyright © 2019 AndyCuiYTT. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func cxg_loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.cxg_gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    public func cxg_loadGif(url: String) {
        DispatchQueue.global().async {
            let image = UIImage.cxg_gif(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
        
    @available(iOS 9.0, *)
    public func cxg_loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.cxg_gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
