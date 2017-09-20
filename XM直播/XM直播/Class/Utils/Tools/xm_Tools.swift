//
//  xm_Tools.swift
//  XM直播
//
//  Created by GDBank on 2017/8/14.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Photos


extension NSObject{
    ///MARK: 根据类型转换成对应的VC
    public func xm_ClassFromString(className: String) -> UIViewController! {
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let classStringName = "\(appName).\(className)"
            let classType = NSClassFromString(classStringName) as? UIViewController.Type
            if let type = classType {
                let newVC = type.init()
                return newVC
            }
        }
        return nil;
    }
    ///MARK: 转换数量单位
    public func xm_NumberWithString(count: Int) -> NSString {
        switch count {
        case 0..<10000:
            return "\(count)人" as NSString
        case 10000..<10000000:
            return "\(count/10000)万人" as NSString
        default:
            return "\(count)" as NSString
        }
    }
    ///MARK:根据文字获取高度
    public func xm_GetTextHeigh(textStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: width, height: 10000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    ///MARK: 根据文字获取宽度
    public func xm_GetTexWidth(textStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        let normalText: String = textStr
        let size = CGSize.init(width: 10000, height: height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    
    ///MARK: 根据当前时间转换成时间戳       2017.8.30 - 14656786786
    public func getCurrentTimeStamp() -> Int{
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    ///MARK: 根据时间戳转换成时间格式
    public func getCurrentDateString(timeStamp: Int) -> String {
        
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let Dates = dformatter.string(from: date)
        return  Dates
    }
    ///MARK: 获取当前时间字符串
    public func getCurrentDate() -> String {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        print("当前日期时间：\(dformatter.string(from: now))")
        return "\(dformatter.string(from: now))"
    }
}

