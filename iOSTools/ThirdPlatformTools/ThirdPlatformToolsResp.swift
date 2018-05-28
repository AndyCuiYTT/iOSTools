//
//  ThirdPlatformToolsResp.swift
//  iOSTools
//
//  Created by qiuweniOS on 2018/5/28.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

class ThirdPlatformToolsResp: NSObject {
    
    static private var thirdResp: ThirdPlatformToolsResp?
    
    class func shareInstance() -> ThirdPlatformToolsResp {
        if thirdResp == nil {
            thirdResp = ThirdPlatformToolsResp()
        }
        return thirdResp!
    }
    
    
    var qqLoginResult: ((YTTLoginResultStruct) -> Void)?
    
    
    var wxLoginResult: ((YTTLoginResultStruct) -> Void)?
    
}


// MARK: - QQ 回调
extension ThirdPlatformToolsResp: TencentSessionDelegate {
  
    
    func tencentDidLogin() {
        if ThirdPlatformTools.tencentOAuth?.accessToken != "" {
            ThirdPlatformTools.tencentOAuth?.getUserInfo()
        }else {
            self.qqLoginResult?(YTTLoginResultStruct(errCode: -4, errmsg: "授权失败"))
        }
    }

    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            self.qqLoginResult?(YTTLoginResultStruct(errCode: -1, errmsg: "用户取消登录"))
        }else {
            self.qqLoginResult?(YTTLoginResultStruct(errCode: -2, errmsg: "登录失败"))
        }
    }

    func tencentDidNotNetWork() {
        self.qqLoginResult?(YTTLoginResultStruct(errCode: -3, errmsg: "无网络连接，请设置网络"))
    }

    func getUserInfoResponse(_ response: APIResponse!) {
        self.qqLoginResult?(YTTLoginResultStruct(errCode: 0, result: response.jsonResponse as! [String : Any]))
    }

    
    
    
}

// MARK: - 微信回调
extension ThirdPlatformToolsResp: WXApiDelegate {
    public func onResp(_ resp: BaseResp!) {
        
        if resp is SendAuthResp {
            switch resp.errCode {
            case 0:
                
                shareNetwork("https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(ThirdPlatformTools.shareDelegate?.getWxAppidAndSecret().appID ?? "")&secret=\(ThirdPlatformTools.shareDelegate?.getWxAppidAndSecret().secret ?? "")&code=\((resp as! SendAuthResp).code)&grant_type=authorization_code", result: { [weak self](dic) in
                    if dic.keys.contains("errcode") {
                        self?.wxLoginResult?(YTTLoginResultStruct(errCode: dic["errcode"] as! Int, errmsg: dic["errmsg"] as! String))
                    }else {
                        if let access_token = dic["access_token"] as? String, let openid =  dic["openid"] as? String {
                            self?.getWxUserInfo(access_token, openid: openid)
                        }else {
                            self?.wxLoginResult?(YTTLoginResultStruct(errCode: -9, errmsg: "授权失败"))
                        }
                    }
                })
            case -4:
                self.wxLoginResult?(YTTLoginResultStruct(errCode: -4, errmsg: "用户拒绝授权"))
            case -2:
                self.wxLoginResult?(YTTLoginResultStruct(errCode: -2, errmsg: "用户取消"))
            default: break
            }
        }
        
        if resp is SendMessageToWXResp {
            ThirdPlatformTools.shareDelegate?.shareResult(platform: .weChat, errCode: Int(resp.errCode), errmsg: resp.errStr)
        }
        
    }
    
    func getWxUserInfo(_ access_token: String, openid: String) {
        shareNetwork("https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)", result: {[weak self] (result) in
            if result.keys.contains("errcode") {
                self?.wxLoginResult?(YTTLoginResultStruct(errCode: result["errcode"] as! Int, errmsg: result["errmsg"] as! String))
            }else {
                self?.wxLoginResult?(YTTLoginResultStruct(errCode: 0, result: result))
            }
        })
    }
}



// MARK: - 简易网络请求
extension ThirdPlatformToolsResp {
    
    private func shareNetwork(_ urlStr: String, result: @escaping ((Dictionary<String, Any>)) -> Void) {
        
        if let url = URL(string: urlStr) {
            let urlSession = URLSession.shared
            urlSession.dataTask(with: url) { (data, reponse, error) in
                if error != nil {
                    self.wxLoginResult?(YTTLoginResultStruct(errCode: -1, errmsg: "请求失败"))
                }else {
                    if data != nil, let dic = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves), let resultDic = dic as? Dictionary<String, Any> {
                        result(resultDic)
                    }
                }
            }
        }
    }
}

