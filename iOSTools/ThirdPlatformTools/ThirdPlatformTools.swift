//
//  ThirdPlatformTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/5/28.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import AVFoundation


public enum YTTSharePlatform {
    case weChat
    case QQ
    case weibo
}

struct YTTToolsResultStruct {
    var errCode: Int! // 0 为成功
    var errmsg: String?
    var result: [String: Any]?
    
    init(errCode: Int, errmsg: String) {
        self.errCode = errCode
        self.errmsg = errmsg
        self.result = [:]
    }
    
    init(errCode: Int, result: [String: Any]) {
        self.errCode = errCode
        self.errmsg = "success"
        self.result = result
    }
}


public protocol YTTToolsProtocol {

    func wxNotInstall()
    func wxNotSupport()
    func getWxAppidAndSecret() -> (appID: String, secret: String)
    
    
    func qqNotInstall()
    func getQQAppid() -> String
    
    func shareResult(platform: YTTSharePlatform, errCode: Int, errmsg: String)
}

extension YTTToolsProtocol {
    func wxNotInstall() {}
    func wxNotSupport() {}
    func getWxAppidAndSecret() -> (appID: String, secret: String) {return ("","")}
    
    
    func qqNotInstall() {}
    func getQQAppid() -> String {return ""}
    
    func shareResult(platform: YTTSharePlatform, errCode: Int, errmsg: String) {}
}



public class ThirdPlatformTools {

    
    static public var delegate: YTTToolsProtocol?
    
    
    static public let share: YTTShareManager = {
        return YTTShareManager(ThirdPlatformTools.delegate)
    }()
    
    static public let login: YTTLoginTools = {
        return YTTLoginTools()
    }()
    
    static public let pay: YTTPayTools = {
        return YTTPayTools()
    }()
    
    static var tencentOAuth: TencentOAuth?
    
    class func registerQQApp() {
        tencentOAuth = TencentOAuth(appId: ThirdPlatformTools.delegate?.getQQAppid(), andDelegate: ThirdPlatformToolsResp.shareInstance())
    }
    
    class func registerWxApp() {
        WXApi.registerApp(ThirdPlatformTools.delegate?.getWxAppidAndSecret().appID)
    }
    
    class func application(open url: URL, sourceApplication: String?) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processAuthResult(url, standbyCallback: { (result) in
                
            })
            return true
        }
        
        
        if sourceApplication == "com.tencent.xin" {
            return WXApi.handleOpen(url, delegate: ThirdPlatformToolsResp.shareInstance())
        }
        
        if sourceApplication == "com.tencent.mqq" {
            return TencentOAuth.handleOpen(url)
        }
        return true
    }
    
    
}
