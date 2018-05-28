//
//  ThirdPlatformTools.swift
//  iOSTools
//
//  Created by qiuweniOS on 2018/5/28.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import AVFoundation


public enum SharePlatform {
    case weChat
    case QQ
    case weibo
}

struct YTTLoginResultStruct {
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


public protocol YTTShareProtocol {

    func wxNotInstall()
    func wxNotSupport()
    func getWxAppidAndSecret() -> (appID: String, secret: String)
    
    
    func qqNotInstall()
    func getQQAppid() -> String
    
    func shareResult(platform: SharePlatform, errCode: Int, errmsg: String)
}


public class ThirdPlatformTools {

    
    static public var shareDelegate: YTTShareProtocol?
    
    
    static public let share: YTTShareManager = {
        return YTTShareManager(ThirdPlatformTools.shareDelegate)
    }()
    
    static public let login: YTTLoginTools = {
        return YTTLoginTools()
    }()
    
    static public let pay: YTTShareManager = {
        return YTTShareManager(ThirdPlatformTools.shareDelegate)
    }()
    
    static var tencentOAuth: TencentOAuth?
    
    class func registerQQApp() {
        tencentOAuth = TencentOAuth(appId: ThirdPlatformTools.shareDelegate?.getQQAppid(), andDelegate: ThirdPlatformToolsResp.shareInstance())
    }
    
    class func registerWxApp() {
        
        WXApi.registerApp(ThirdPlatformTools.shareDelegate?.getWxAppidAndSecret().appID)
    }
    
    
}
