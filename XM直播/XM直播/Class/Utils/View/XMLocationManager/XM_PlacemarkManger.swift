//
//  XM_PlacemarkManger.swift
//  XM直播
//
//  Created by GDBank on 2017/8/16.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import CoreLocation


typealias UserLocation = ((_ location: CLLocation?) -> Void) /////获取经当前用户信息
typealias UserlocationError  = ((_ error : NSError?)-> Void) ///获取定位失败
typealias LocationPlacemark  = ((_ placemark:XM_PlacemarkModel?)-> Void) /////获取地理位置
typealias LocationPlacemarkError  = ((_ error : NSError?)-> Void)

class XM_PlacemarkManger: NSObject {
    ///初始化单利类
    class var sharedInstance: XM_PlacemarkManger {
        struct Static {
            static let sharedInstance = XM_PlacemarkManger()
        }
        return Static.sharedInstance
    }
    // 定义闭包变量
    fileprivate var userlocation: UserLocation?
    fileprivate var userLocationError: UserlocationError?
    fileprivate var locationPlacemark: LocationPlacemark?
    fileprivate var LocationPlacemarkError: LocationPlacemarkError?
    ///MARK: 创建编码反编码类
    fileprivate var locationManager: CLLocationManager?
    fileprivate var geocoder: CLGeocoder?
    
    ///MARK: 获取用户经纬度及地理信息
    open func getUserLocation ( _ location: @escaping UserLocation ,_ error :@escaping UserlocationError , _ locationPlacemark: @escaping LocationPlacemark ,_ Placemarkerror :@escaping LocationPlacemarkError){
          startLocation()
        guard CLLocationManager.locationServicesEnabled() == true else { return }
        self.userlocation = location
        self.userLocationError = error
        self.LocationPlacemarkError = Placemarkerror
        self.locationPlacemark = locationPlacemark
    }
    ///MARK: 获取城市地理信息
    open func getPlacemark (_ locationPlacemark: @escaping LocationPlacemark ,_ Placemarkerror :@escaping LocationPlacemarkError){
          startLocation()
        self.locationPlacemark = locationPlacemark
        self.LocationPlacemarkError = Placemarkerror
    }
    ///MARK: 获取输入地点返回经纬度
    open func getLocation (_ address :NSString , _ location : @escaping UserLocation ,_ Placemarkerror :@escaping LocationPlacemarkError){
          startLocation()
        self.userlocation = location
        self.LocationPlacemarkError = Placemarkerror
        geocoder?.geocodeAddressString(address as String) { [unowned self] (placemarks, error) in
            if (placemarks?.isEmpty)!  == false {
                let palceMark:CLPlacemark = (placemarks?.first)!
                if self.userlocation != nil {
                    self.userlocation!(palceMark.location)
                }
            }else {
                if self.LocationPlacemarkError != nil {
                    self.LocationPlacemarkError!(error as NSError?)
                }
            }
        }
    }
     /// MARK: 定位功能开启
    open func startLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    override init() {
        super.init()
        locationManager = CLLocationManager()        // 初始化locationManager
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest //定位精准度
        locationManager?.distanceFilter = 20 // 超出范围更新位置信息
        locationManager?.requestWhenInUseAuthorization() ///MARK: 请求授权
        geocoder = CLGeocoder()  // 初始化geocoder
    }
}

extension XM_PlacemarkManger: CLLocationManagerDelegate {              ///MARK: CLLocationManagerDelegate代理方法
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let location :CLLocation = locations.last {
            if self.userlocation != nil {
                self.userlocation!(location)
            }
            geocoder?.reverseGeocodeLocation(location, completionHandler: {  [unowned self] (placemarks, error) in
                if let placeMark:CLPlacemark  = placemarks?.first{
                    if self.locationPlacemark != nil {
                        print("地理坐标信息 = :\(placeMark)")
                        self.locationPlacemark!(XM_PlacemarkModel.init(placeMark: placeMark))
                    }
                }else{
                    if self.LocationPlacemarkError != nil {
                        self.LocationPlacemarkError!(error! as NSError)
                    }
                }
            })
        }
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (self.userLocationError != nil) {
            self.userLocationError!(error as NSError)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("用户未决定")
        case .restricted:
            print("访问受限")
        case .denied: 
            if CLLocationManager.locationServicesEnabled() {
                print("定位开启,但被拒绝")
                if let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingUrl) && Double(UIDevice.current.systemVersion)! >= 8.0 {
                        //iOS8可直接跳转到设置界面
                        let alertVC = UIAlertController(title: "提示", message: "定位功能被拒绝，是否前往设置开启", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                        })
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                            UIApplication.shared.openURL(settingUrl)
                        })
                        alertVC.addAction(cancelAction)
                        alertVC.addAction(okAction)
                        let vc = UIApplication.shared.keyWindow?.rootViewController
                        vc?.present(alertVC, animated: true, completion: nil)
                    }
                } else {
                    let alertVC = UIAlertController(title: "提示", message: "定位功能被拒绝，请在设置中开启", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                    })
                    alertVC.addAction(cancelAction)
                    let vc = UIApplication.shared.keyWindow?.rootViewController
                    vc?.present(alertVC, animated: true, completion: nil)
                }
                
            } else {
                print("定位关闭,不可用")
                if let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingUrl) && Double(UIDevice.current.systemVersion)! >= 8.0 {
                        //iOS8可直接跳转到设置界面
                        let alertVC = UIAlertController(title: "提示", message: "定位功能被拒绝，是否前往设置开启", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                        })
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                            UIApplication.shared.openURL(settingUrl)
                        })
                        alertVC.addAction(cancelAction)
                        alertVC.addAction(okAction)
                        let vc = UIApplication.shared.keyWindow?.rootViewController
                        vc?.present(alertVC, animated: true, completion: nil)
                        
                    } else {
                        let alertVC = UIAlertController(title: "提示", message: "定位服务未开启\n打开方式:设置->隐私->定位服务", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                        })
                        alertVC.addAction(cancelAction)
                        let vc = UIApplication.shared.keyWindow?.rootViewController
                        vc?.present(alertVC, animated: true, completion: nil)
                    }
                    
                }
            }
            
        case .authorizedAlways:
            print("获取前后台定位授权")
        case .authorizedWhenInUse:
            print("获取前台定位授权")
        }
    }
}
