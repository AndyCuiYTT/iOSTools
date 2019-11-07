//
//  LocationTools.swift
//
//  Created by CuiXg on 2018/6/5.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit
import CoreLocation


// 创建对象注意生命周期
class YTTLocationTools: NSObject {
    
    
    private var locationManager: CLLocationManager?
    
    private var finishLocations: ((CLLocationManager, [CLLocation]) -> Void)?
    
    
    func startLocation(locations: @escaping ((CLLocationManager, [CLLocation]) -> Void)) {
        guard CLLocationManager.locationServicesEnabled() else {
            
            let alertVC = UIAlertController(title: "温馨提示", message: "请在设置中打开定位功能", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            return
        }
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
            let alertVC = UIAlertController(title: "温馨提示", message: "请在设置中打开定位功能", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
            return
        }
        finishLocations = locations
        locationManager = CLLocationManager()
        // 设置精度
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        // 请求权限
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        // 设置代理
        locationManager?.delegate = self
        // 定位范围 (移动与上次定位位置超过这距离再次定位)
        locationManager?.distanceFilter = 10
        // 定位精度
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 开始定位
        locationManager?.startUpdatingLocation()
    }
    
    func stopLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func getAddress(withLocation location: CLLocation, addresses: @escaping ([(country: String, province: String, city: String, area: String, street: String, name: String, detailedAddress: String)]) -> Void) {
        var address: [(country: String, province: String, city: String, area: String, street: String, name: String, detailedAddress: String)] = []
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            
            if let marks = placeMarks {
                for placeMake in marks {
                    if let detaileAddresses = placeMake.addressDictionary?["FormattedAddressLines"] as? [String], let detaileAddress = detaileAddresses.first {
                        address.append((placeMake.country ?? "", placeMake.administrativeArea ?? "", placeMake.locality ?? "", placeMake.subLocality ?? "", "\(placeMake.thoroughfare ?? "")\(placeMake.subThoroughfare ?? "")", placeMake.name ?? "", detaileAddress))
                    }
                }
            }
            addresses(address)
        }
    }
    
    func getLocation(withAddress address: String, locations: @escaping ([CLLocation]) -> Void) {
        let geoCoder = CLGeocoder()
        var locas: [CLLocation] = []
        geoCoder.geocodeAddressString(address) { (placeMarks, error) in
            if let marks = placeMarks {
                for placeMake in marks {
                    if let location = placeMake.location {
                        locas.append(location)
                    }
                }
            }
            locations(locas)
        }
    }
}

extension YTTLocationTools: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.finishLocations?(manager, locations)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
    }
    
}
