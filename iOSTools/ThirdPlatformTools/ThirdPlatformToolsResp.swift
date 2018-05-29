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
    
    
    var qqLoginResult: ((YTTToolsResultStruct) -> Void)?
    
    
    var wxLoginResult: ((YTTToolsResultStruct) -> Void)?
    
    var wxPayResult: ((YTTToolsResultStruct) -> Void)?
    
}


// MARK: - QQ 回调
extension ThirdPlatformToolsResp: TencentSessionDelegate {
  
    
    func tencentDidLogin() {
        if ThirdPlatformTools.tencentOAuth?.accessToken != "" {
            ThirdPlatformTools.tencentOAuth?.getUserInfo()
        }else {
            self.qqLoginResult?(YTTToolsResultStruct(errCode: -4, errmsg: "授权失败"))
            self.qqLoginResult = nil
        }
    }

    func tencentDidNotLogin(_ cancelled: Bool) {
        if cancelled {
            self.qqLoginResult?(YTTToolsResultStruct(errCode: -1, errmsg: "用户取消登录"))
            self.qqLoginResult = nil
        }else {
            self.qqLoginResult?(YTTToolsResultStruct(errCode: -2, errmsg: "登录失败"))
            self.qqLoginResult = nil
        }
    }

    func tencentDidNotNetWork() {
        self.qqLoginResult?(YTTToolsResultStruct(errCode: -3, errmsg: "无网络连接，请设置网络"))
        self.qqLoginResult = nil
    }

    func getUserInfoResponse(_ response: APIResponse!) {
        self.qqLoginResult?(YTTToolsResultStruct(errCode: 0, result: response.jsonResponse as! [String : Any]))
        self.qqLoginResult = nil
    }

    
    
    
}

// MARK: - 微信回调
extension ThirdPlatformToolsResp: WXApiDelegate {
    public func onResp(_ resp: BaseResp!) {
        
        if resp is SendAuthResp {
            switch resp.errCode {
            case 0:
                
                shareNetwork("https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(ThirdPlatformTools.delegate?.getWxAppidAndSecret().appID ?? "")&secret=\(ThirdPlatformTools.delegate?.getWxAppidAndSecret().secret ?? "")&code=\((resp as! SendAuthResp).code)&grant_type=authorization_code", result: { [weak self](dic) in
                    if dic.keys.contains("errcode") {
                        self?.wxLoginResult?(YTTToolsResultStruct(errCode: dic["errcode"] as! Int, errmsg: dic["errmsg"] as! String))
                    }else {
                        if let access_token = dic["access_token"] as? String, let openid =  dic["openid"] as? String {
                            self?.getWxUserInfo(access_token, openid: openid)
                        }else {
                            self?.wxLoginResult?(YTTToolsResultStruct(errCode: -9, errmsg: "授权失败"))
                        }
                    }
                })
            case -4:
                self.wxLoginResult?(YTTToolsResultStruct(errCode: -4, errmsg: "用户拒绝授权"))
            case -2:
                self.wxLoginResult?(YTTToolsResultStruct(errCode: -2, errmsg: "用户取消"))
            default: break
            }
            
            defer {
                self.wxLoginResult = nil
            }
        }
        
        if resp is SendMessageToWXResp {
            ThirdPlatformTools.delegate?.shareResult(platform: .weChat, errCode: Int(resp.errCode), errmsg: resp.errStr)
        }
        
        if resp is PayResp {
            switch resp.errCode {
            case 0:
                self.wxPayResult?(YTTToolsResultStruct(errCode: 0, result: [:]))
            case -1:
                self.wxPayResult?(YTTToolsResultStruct(errCode: -1, errmsg: "错误"))
            case -2:
                self.wxPayResult?(YTTToolsResultStruct(errCode: -2, errmsg: "用户取消"))
            default:
                break
            }
            defer {
                self.wxPayResult = nil
            }
        }
        
    }
    
    
    
    func getWxUserInfo(_ access_token: String, openid: String) {
        shareNetwork("https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)", result: {[weak self] (result) in
            if result.keys.contains("errcode") {
                self?.wxLoginResult?(YTTToolsResultStruct(errCode: result["errcode"] as! Int, errmsg: result["errmsg"] as! String))
                self?.wxLoginResult = nil
            }else {
                self?.wxLoginResult?(YTTToolsResultStruct(errCode: 0, result: result))
                self?.wxLoginResult = nil
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
                    self.wxLoginResult?(YTTToolsResultStruct(errCode: -1, errmsg: "请求失败"))
                    self.wxLoginResult = nil
                }else {
                    if data != nil, let dic = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves), let resultDic = dic as? Dictionary<String, Any> {
                        result(resultDic)
                    }
                }
            }
        }
    }
}

