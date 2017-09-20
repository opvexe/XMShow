//
//  XM_PlacemarkModel.swift
//  XM直播
//
//  Created by GDBank on 2017/8/23.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

extension String {
    
    func substring(s: Int, _ e: Int? = nil) -> String {
        
        let start = s >= 0 ? self.startIndex : self.endIndex
        
        let startIndex = index(start, offsetBy: s)
        
        var end: String.Index
        var endIndex: String.Index
        if(e == nil){
            end = self.endIndex
            endIndex = self.endIndex
        } else {
            end = e! >= 0 ? self.startIndex : self.endIndex
            
            endIndex = index(end, offsetBy: e!)
        }
        let range = Range<String.Index>(startIndex..<endIndex)
        
        return self.substring(with: range)
        
    }
}

class XM_PlacemarkModel: NSObject {
    
    ///MARK: 地理信息
    var name: String?
    var country: String?
    var province: String?
    {
        didSet{
            if (province?.hasSuffix("省"))! {
                province =  province?.substring(s: 0, province!.characters.count - 1)
            }else if(province?.hasSuffix("市"))!{
                province =  province?.substring(s: 0, province!.characters.count - 1)
            }
        }
    }
    var city: String?
    {
        didSet{
            if (city?.hasSuffix("市辖区"))! {
                city =  city?.substring(s: 0, (city?.characters.count)! - 3)
            }
            if(city?.hasSuffix("市"))!{
                city =  city?.substring(s: 0, (city?.characters.count)! - 1)
            }
            if((city?.hasSuffix("香港特別行政區"))!||(city?.hasSuffix("香港特别行政区"))!){
                city = "香港"
            }
            if((city?.hasSuffix("澳門特別行政區"))!||(city?.hasSuffix("澳门特别行政区"))!){
                city = "澳门"
            }
        }
    }
    var county: String?         ///MARK: 区
    var address: String?
    var placemarkId: Int?
    var  type:String?
    ///MARK: 经纬度信息
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?

    open func getProvinceAndCity() ->String {
        
        var  provinceName = province
        var cityName  = city
        if provinceName == cityName {
            provinceName = ""
        }
        if (cityName?.hasSuffix("市辖区"))! {
            city =  city?.substring(s: 0, (city?.characters.count)! - 3)
        }
        if(cityName?.hasSuffix("市"))!{
            city =  city?.substring(s: 0, (city?.characters.count)! - 1)
        }
        if((cityName?.hasSuffix("香港特別行政區"))!||(cityName?.hasSuffix("香港特别行政区"))!){
            cityName = "香港"
        }
        if((cityName?.hasSuffix("澳門特別行政區"))!||(cityName?.hasSuffix("澳门特别行政区"))!){
            cityName = "澳门"
        }
        return  (provinceName?.appending(cityName! as String))!
    }
    
    init(placeMark: CLPlacemark) {
        super.init()
        self.city = placeMark.locality
        self.country = placeMark.country
        self.county  = placeMark.subLocality
        self.province = placeMark.administrativeArea
        guard let streeNub = placeMark.subThoroughfare else {return }
        self.address = placeMark.thoroughfare! + streeNub
        
    }
}
