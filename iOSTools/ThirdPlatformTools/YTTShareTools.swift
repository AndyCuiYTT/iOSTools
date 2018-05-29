//
//  ShareTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

// 添加微信 SDK 包: pod 'WechatOpenSDK'


import Foundation

enum QQScene {
    case QQ
    case QZone
    case Collection
}


public class YTTShareManager: NSObject {

    private var delegate: YTTToolsProtocol?

    private var wxLoginResult: ((YTTToolsResultStruct) -> Void)?

    public init(_ delegate: YTTToolsProtocol?) {
        self.delegate = delegate
    }

}


// MARK: - 微信分享
extension YTTShareManager {
    
    func wx_shareText(_ text: String, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            delegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            delegate?.wxNotSupport()
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
            delegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            delegate?.wxNotSupport()
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
            delegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            delegate?.wxNotSupport()
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
            delegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            delegate?.wxNotSupport()
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
            delegate?.wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            delegate?.wxNotSupport()
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





// MARK: - QQ 分享
extension YTTShareManager {
    func qq_shareText(_ text: String, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        
        let txtObj = QQApiTextObject(text: text)
        let req = SendMessageToQQReq(content: txtObj)
        
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            txtObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            txtObj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
        
    }
    
    func qq_shareImage(thumbImage: UIImage, image: UIImage, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        
        let imgObj = QQApiImageObject(data: UIImagePNGRepresentation(image), previewImageData: UIImagePNGRepresentation(thumbImage), title: tittle, description: description)
        let req = SendMessageToQQReq(content: imgObj)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
        
    }
    
    func qq_shareImagesToQZone(images: [UIImage], tittle: String?, extMap: Dictionary<String, Any>?) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
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
            delegate?.qqNotInstall()
            return
        }
        
        let newsObj = QQApiNewsObject.object(with: URL(string: newsUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: newsObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (newsObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (newsObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    
    func qq_shareAudio(thumbImageURL: String, AudioUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        
        let audioObj = QQApiAudioObject.object(with: URL(string: AudioUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: audioObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (audioObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (audioObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    
    func qq_shareVideo(thumbImageURL: String, VideoUrl: String, tittle: String?, description: String?, scene: QQScene) {
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        
        let videoObj = QQApiVideoObject.object(with: URL(string: VideoUrl), title: tittle, description: description, previewImageURL: URL(string: thumbImageURL))
        let req = SendMessageToQQReq(content: videoObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (videoObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (videoObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    
    
    func qq_shareNews(thumbImage: UIImage, newsUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        let newsObj = QQApiNewsObject.object(with: URL(string: newsUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: newsObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (newsObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (newsObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    
    func qq_shareAudio(thumbImage: UIImage, AudioUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        let audioObj = QQApiAudioObject.object(with: URL(string: AudioUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: audioObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (audioObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (audioObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    
    func qq_shareVideo(thumbImage: UIImage, VideoUrl: String, tittle: String?, description: String?, scene: QQScene) {
        
        guard TencentOAuth.iphoneQQInstalled() else {
            delegate?.qqNotInstall()
            return
        }
        let videoObj = QQApiVideoObject.object(with: URL(string: VideoUrl), title: tittle, description: description, previewImageData: UIImagePNGRepresentation(thumbImage))
        let req = SendMessageToQQReq(content: videoObj as! QQApiObject)
        switch scene {
        case .QQ:
            qq_ShareResultCode(QQApiInterface.send(req))
        case .QZone:
            (videoObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
            qq_ShareResultCode(QQApiInterface.sendReq(toQZone: req))
        case .Collection:
            (videoObj as! QQApiObject).cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
            qq_ShareResultCode(QQApiInterface.send(req))
        }
    }
    

    private func qq_ShareResultCode(_ resultCode: QQApiSendResultCode) {
        
        if resultCode == EQQAPISENDSUCESS {
            self.delegate?.shareResult(platform: .QQ, errCode: 0, errmsg: "分享成功")
        }else {
             self.delegate?.shareResult(platform: .QQ, errCode: Int(resultCode.rawValue), errmsg: "分享失败")
        }
    }
}


