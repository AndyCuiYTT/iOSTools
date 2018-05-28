//
//  AppDelegate.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ThirdPlatformTools.shareDelegate = self
        ThirdPlatformTools.registerQQApp()
        ThirdPlatformTools.registerWxApp()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: ThirdPlatformToolsResp.shareInstance())
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if sourceApplication == "com.tencent.xin" {
            return WXApi.handleOpen(url, delegate: ThirdPlatformToolsResp.shareInstance())
        }
        
        if sourceApplication == "com.tencent.mqq" {
            return TencentOAuth.handleOpen(url)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }

}

extension AppDelegate: YTTShareProtocol {
    func wxNotInstall() {
        
    }
    
    func wxNotSupport() {
        
    }
    
    func getWxAppidAndSecret() -> (appID: String, secret: String) {
        return ("1111","11111")
    }
    
    func qqNotInstall() {
        print("QQ 未安装")
    }
    
    func getQQAppid() -> String {
        return "1106931746"
    }
    
    func shareResult(platform: SharePlatform, errCode: Int, errmsg: String) {
        print("\(errCode)" + errmsg)
    }
    
    
}

