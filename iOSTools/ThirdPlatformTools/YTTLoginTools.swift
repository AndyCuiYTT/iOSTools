//
//  YTTLoginTools.swift
//  iOSTools
//
//  Created by qiuweniOS on 2018/5/28.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

public class YTTLoginTools: NSObject {

}

// MARK: - QQ 登录
extension YTTLoginTools {
    
    
    /// QQ 登录
    ///
    /// - Parameters:
    ///   - permissions: 授权信息列表
    ///   - result: 授权后回调
    func qq_login(permissions: [String], result: @escaping (YTTLoginResultStruct) -> Void) {
        ThirdPlatformTools.tencentOAuth?.authorize(permissions, inSafari: false)
        ThirdPlatformToolsResp.shareInstance().qqLoginResult = result
    }
    
    func TIM_login(permissions: [String], result: @escaping (YTTLoginResultStruct) -> Void) {

        ThirdPlatformTools.tencentOAuth?.authorize(permissions, inSafari: false)
        ThirdPlatformToolsResp.shareInstance().qqLoginResult = result
    }
}

// MARK: - 微信登录
extension YTTLoginTools {
    
    
    /// 微信登录请请求发起
    ///
    /// - Parameters:
    ///   - scope: 应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    ///   - state: 用于保持请求和回调的状态，授权请求后原样带回给第三方。
    func wx_login(_ scope: String = "snsapi_userinfo", state: String, result: @escaping (YTTLoginResultStruct) -> Void) {
        guard WXApi.isWXAppInstalled() else {
            ThirdPlatformTools.shareDelegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            ThirdPlatformTools.shareDelegate?.wxNotSupport()
            return
        }
        let req = SendAuthReq()
        req.scope = scope
        req.state = state
        WXApi.send(req)
        ThirdPlatformToolsResp.shareInstance().wxLoginResult = result
    }
}







