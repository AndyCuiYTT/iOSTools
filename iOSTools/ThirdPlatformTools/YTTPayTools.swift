//
//  YTTPayTools.swift
//  iOSTools
//
//  Created by AndyCui on 2018/5/29.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

public class YTTPayTools: NSObject {

}


// MARK: - 微信支付
extension YTTPayTools {
    
    func wx_pay(orderInfo: [String: String], result: @escaping (YTTToolsResultStruct) -> Void) {
        
        guard WXApi.isWXAppInstalled() else {
            ThirdPlatformTools.delegate?.wxNotInstall()
            return
        }
        
        let request = PayReq()
        request.openID = orderInfo["openID"]
        request.partnerId = orderInfo["partnerId"]
        request.prepayId = orderInfo["prepayId"]
        request.package = orderInfo["package"]
        request.nonceStr = orderInfo["nonceStr"]
        request.timeStamp = UInt32(orderInfo["timeStamp"]!)!
        request.sign = orderInfo["sign"]
        WXApi.send(request)
        ThirdPlatformToolsResp.shareInstance().wxPayResult = result
    }
}



// MARK: - 支付宝支付
extension YTTPayTools {
    
    func ali_pay(orderInfo: String, signedString: String, scheme: String, result: @escaping (YTTToolsResultStruct) -> Void) {
        
        
        let payOrder = "\(orderInfo)&sign=\(signedString)&sign_type=RSA"
        AlipaySDK.defaultService().payOrder(payOrder, fromScheme: scheme) { (payResult) in
            if let code = payResult?["code"] {
                switch code as! Int {
                case 9000:
                    result(YTTToolsResultStruct(errCode: 9000, result: [:]))
                case 4000:
                    result(YTTToolsResultStruct(errCode: 4000, errmsg: "支付失败"))
                case 6001:
                    result(YTTToolsResultStruct(errCode: 6001, errmsg: "支付取消"))
                default:
                    result(YTTToolsResultStruct(errCode: -1, errmsg: "支付失败"))
                }
            }
        }
        
        
    }
    
    
    
    
}
