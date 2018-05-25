//
//  ShareTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

// 添加微信 SDK 包: pod 'WechatOpenSDK'


import Foundation

enum SharePlatform {
    case weChat
    case QQ
    case weibo
}

enum QQScene {
    case QQ
    case QZone
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


class YTTShareManager: NSObject {

    var shareResult: ((SharePlatform, Int, String) -> Void)?
    
    
    
// MARK: - 微信相关属性
    var wxNotInstall: (() -> Void)?
    var wxNotSupport: (() -> Void)?
    private var wxAppid: String?
    private var wxSecret: String?
    private var wxLoginResult: ((YTTLoginResultStruct) -> Void)?

// MARK: - QQ相关属性
    var qqNotInstall: (() -> Void)?
//    var qqNotSupport: (() -> Void)?
    private var qqAppid: String?
    private var tencentOAuth: TencentOAuth?
    private var qqLoginResult: ((YTTLoginResultStruct) -> Void)?
    

    
    private static var manager: YTTShareManager?
    
    class func shareInstance() -> YTTShareManager{
        if manager == nil {
            manager = YTTShareManager()
        }
        return manager!
    }
    
    
    
    func registerWxApp(appid: String, secret: String = "") {
        WXApi.registerApp(appid)
        wxAppid = appid
        wxSecret = secret
    }
    
    func registerQQApp(appid: String) {
        qqAppid = appid
        tencentOAuth = TencentOAuth(appId: appid, andDelegate: self)
    }

}


// MARK: - 微信分享
extension YTTShareManager {
    
    func wx_shareText(_ text: String, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        
        let req = SendMessageToWXReq()
        req.text = text
        req.bText = true
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
        
    }
    
    func wx_shareImage(thumbImage: UIImage, image: UIImage, tittle: String?, description: String?, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        
        let message = WXMediaMessage()
        message.setThumbImage(thumbImage)
        let imageObject = WXImageObject()
        imageObject.imageData = UIImagePNGRepresentation(image)
        message.mediaObject = imageObject
        message.title = tittle
        message.description = description
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
        
    }
    
    func wx_shareWeb(thumbImage: UIImage, webpageUrl: String, tittle: String?, description: String?, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        let message = WXMediaMessage()
        message.setThumbImage(thumbImage)
        message.title = tittle
        message.description = description
        
        let webPageObject = WXWebpageObject()
        webPageObject.webpageUrl = webpageUrl
        message.mediaObject = webPageObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
    }
    
    func wx_shareVideo(thumbImage: UIImage, videoUrl: String, videoLowBandUrl: String?, tittle: String?, description: String?, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        let message = WXMediaMessage()
        message.setThumbImage(thumbImage)
        message.title = tittle
        message.description = description
        
        let videoObject = WXVideoObject()
        videoObject.videoUrl = videoUrl
        videoObject.videoLowBandUrl = (videoLowBandUrl == nil) ? videoUrl : videoLowBandUrl
        message.mediaObject = videoObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
        
    }
    
    func wx_shareMusic(thumbImage: UIImage, musicUrl: String, musicLowBandUrl: String?,  musicDataUrl: String, musicLowBandDataUrl: String?, tittle: String?, description: String?, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        let message = WXMediaMessage()
        message.setThumbImage(thumbImage)
        message.title = tittle
        message.description = description
        
        
        let musicObject = WXMusicObject()
        musicObject.musicUrl = musicUrl
        musicObject.musicDataUrl = musicDataUrl
        musicObject.musicLowBandUrl = (musicLowBandUrl == nil) ? musicUrl : musicLowBandUrl
        musicObject.musicLowBandDataUrl = (musicLowBandDataUrl == nil) ? musicDataUrl : musicLowBandDataUrl
        message.mediaObject = musicObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(scene.rawValue)
        WXApi.send(req)
        
    }
}


// MARK: - 微信登录
extension YTTShareManager {
    
    
    /// 微信登录请请求发起
    ///
    /// - Parameters:
    ///   - scope: 应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    ///   - state: 用于保持请求和回调的状态，授权请求后原样带回给第三方。
    func wx_login(_ scope: String = "snsapi_userinfo", state: String, result: @escaping (YTTLoginResultStruct) -> Void) {
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall?()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport?()
            return
        }
        let req = SendAuthReq()
        req.scope = scope
        req.state = state
        WXApi.send(req)
        wxLoginResult = result
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


// MARK: - 微信回调
extension YTTShareManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        
        if resp is SendAuthResp {
            switch resp.errCode {
                case 0:
                
                    shareNetwork("https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(wxAppid ?? "")&secret=\(wxSecret ?? "")&code=\((resp as! SendAuthResp).code)&grant_type=authorization_code", result: { [weak self](dic) in
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
            self.shareResult?(.weChat, Int(resp.errCode), resp.errStr)
        }
        
    }
}



// MARK: - QQ 分享
extension YTTShareManager {
    func qq_shareText(_ text: String, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        let txtObj = QQApiTextObject(text: text)
        let req = SendMessageToQQReq(content: txtObj)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareImage(thumbImage: UIImage, image: UIImage, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        let imgObj = QQApiImageObject(data: UIImagePNGRepresentation(image), previewImageData: UIImagePNGRepresentation(thumbImage), title: tittle, description: description)
        let req = SendMessageToQQReq(content: imgObj)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareImagesToQZone(images: [UIImage], tittle: String?, extMap: Dictionary<String, Any>) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        var imagesData: [Data] = []
        for image in images {
            imagesData.append(UIImagePNGRepresentation(image)!)
        }
        
        let imgObj = QQApiImageArrayForQZoneObject.objectWithimageDataArray(imagesData, title: tittle, extMap: extMap)
        let req = SendMessageToQQReq(content: imgObj as! QQApiObject)
        qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        
    }
    
    
    func qq_shareNews(thumbImageURL: String, newsUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        let newsObj = QQApiNewsObject.object(with: URL(string: newsUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: newsObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareAudio(thumbImageURL: String, AudioUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        let audioObj = QQApiAudioObject.object(with: URL(string: AudioUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: audioObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareVideo(thumbImageURL: String, VideoUrl: String, tittle: String?, description: String?, scene: QQScene) {
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        
        let videoObj = QQApiVideoObject.object(with: URL(string: VideoUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: videoObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    
    func qq_shareNews(thumbImage: UIImage, newsUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        let newsObj = QQApiNewsObject.object(with: URL(string: newsUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: newsObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareAudio(thumbImage: UIImage, AudioUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        let audioObj = QQApiAudioObject.object(with: URL(string: AudioUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: audioObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    
    func qq_shareVideo(thumbImage: UIImage, VideoUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            qqNotInstall?()
            return
        }
        let videoObj = QQApiVideoObject.object(with: URL(string: VideoUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: videoObj as! QQApiObject)
        if scene == .QQ {
            qq_ShareResultCode(QQApiInterface.send(req))
        }else {
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        }
    }
    

    private func qq_ShareResultCode(_ resultCode: QQApiSendResultCode) {
        
        if resultCode == EQQAPISENDSUCESS {
            self.shareResult?(.QQ, 0, "分享成功")
        }else {
            self.shareResult?(.QQ, Int(resultCode.rawValue), "分享失败")
        }
    }
}


// MARK: - QQ 登录
extension YTTShareManager {
    
    
    /// QQ 登录
    ///
    /// - Parameters:
    ///   - permissions: 授权信息列表
    ///   - result: 授权后回调
    func qq_login(permissions: [String], result: @escaping (YTTLoginResultStruct) -> Void) {
//        guard TencentOAuth.iphoneQQInstalled() else {
//            qqNotInstall?()
//            return
//        }
//
//        guard TencentOAuth.iphoneQQSupportSSOLogin() else {
//            qqNotSupport?()
//            return
//        }
        tencentOAuth?.authorize(permissions, inSafari: false)
        self.qqLoginResult = result
    }
    
    func TIM_login(permissions: [String], result: @escaping (YTTLoginResultStruct) -> Void) {
//        guard TencentOAuth.iphoneTIMInstalled() else {
//            qqNotInstall?()
//            return
//        }
        
//        guard TencentOAuth.iphoneTIMSupportSSOLogin() else {
//            qqNotSupport?()
//            return
//        }
        tencentOAuth?.authorize(permissions, inSafari: false)
        self.qqLoginResult = result
    }
}


// MARK: - QQ 回调
extension YTTShareManager: TencentSessionDelegate {
    func tencentDidLogin() {
        
        if tencentOAuth?.accessToken != "" {
            tencentOAuth?.getUserInfo()
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


// MARK: - 简易网络请求
extension YTTShareManager {
    
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
