//
//  ShareTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/4/26.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

// 添加微信 SDK 包: pod 'WechatOpenSDK'


import Foundation


class ShareManager: NSObject {
    
    private static var manager: ShareManager?
    
    class func shareInstance() -> ShareManager{
        if manager == nil {
            manager = ShareManager()
        }
        return manager!
    }
    
    
    
    class func registerApp(wxAppid: String) {
        WXApi.registerApp(wxAppid)
        
    }
    
    func wx_shareText(_ text: String, scene: WXScene) {
        
        guard WXApi.isWXAppInstalled() else {
            wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            wxNotSupport()
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
            wxNotInstall()
            return
        }
        
        guard WXApi.isWXAppSupport() else {
            wxNotSupport()
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
            wxNotInstall()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport()
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
            wxNotInstall()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport()
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
            wxNotInstall()
            return
        }
        guard WXApi.isWXAppSupport() else {
            wxNotSupport()
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

extension ShareManager {
    private func wxNotInstall() {
        print("dddd")
    }
    
    private func wxNotSupport() {
        
    }
}

