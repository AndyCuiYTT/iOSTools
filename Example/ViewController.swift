//
//  ViewController.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let tools = YTTLocationTools()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UIApplication.shared.isStatusBarHidden = true
        
//        let imageView = UIImageView(frame: self.view.frame)
//        imageView.image = UIImage(named: "1.jpeg")?.ytt.resetImageSizeWithHeight(self.view.frame.height - 100)
//        imageView.contentMode = .center
//        self.view.addSubview(imageView)
        
//        let item = DispatchWorkItem {
//            print("dddddddffffffff")
//        }
//
//        item.notify(queue: DispatchQueue.main) {
//            print(Thread.isMainThread)
//            print("dddddddgbccxxssxs")
//        }
//        DispatchQueue.global().async {
//            print(Thread.isMainThread)
//
//            item.perform()
//        }
//
//        let homePath = NSHomeDirectory()
//        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
//        let cachePath = NSSearchPathForDirectoriesInDomains(.preferencePanesDirectory, .userDomainMask, true)
//        let tmpPath = NSTemporaryDirectory()
//
//        let path = Bundle.main.resourcePath
//        let imagePath = Bundle.main.path(forResource: "temp", ofType: "png")
        
        
        
       
        
    }

    @IBAction func click(_ sender: UIButton) {
    
        
        tools.finishLocation = { (manege, location) in
            print(location)
            
            self.tools.getAddress(withLocation: location!, addresses: { (address) in
                print(address)
            })
            
            
            self.tools.stopLocation()
        }
        
        tools.startLocation()
//
//        print("11111")
//
//        ThirdPlatformTools.login.qq_login(permissions: [kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]) { (info) in
//            print(info)
//        }
        
    }
    @IBAction func shareQQ(_ sender: UIButton) {
//
//        print("qqqq")
//
//        ThirdPlatformTools.share.wx_shareText("少时诵诗书", scene: WXSceneSession)
        
        tools.finishLocation = { (manege, location) in
            print(location)
        }
        
        tools.startLocation()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

