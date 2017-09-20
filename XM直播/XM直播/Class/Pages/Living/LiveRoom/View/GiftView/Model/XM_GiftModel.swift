//
//  XM_GiftModel.swift
//  XM直播
//
//  Created by GDBank on 2017/8/22.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import Foundation
import MJExtension

class XM_GiftModel: NSObject {
    
    var img2: String?           //礼物图标
    var subject: String?       //礼物名字
    var coin: String?          //礼物金币
    var oCoin: String?         //礼物金币
    var type: String?          //礼物类型
    var id: String?             //礼物Id
    var time: String?          //礼物时间
    var authInfo: String?
    var gUrl: String?          //gif 礼物动画
    var auth: String?
    
    var xm_isSelected: Bool = false
    
}
extension XM_GiftModel {    ///礼物接口网络请求
    open func loadData(completion: @escaping (_ result:[XM_GiftModel]) -> ()) -> () {               ///逃逸闭包的使用
        XM_Network.request(method: .get, url: GiftRoomUrl, parameters: ["type" : 0, "page" : 1, "rows" : 150]) { (json, error) in
            
            print("礼物数据:\(json)")
            guard let resultDict = json as? [String : Any] else { return}
            guard let DictArrM = resultDict["message"] as? [String : Any] else { return }
            
            var giftArrM = [XM_GiftModel]()
            for i in 0..<DictArrM.count {
                guard let dictList = DictArrM["type\(i+1)"] as? [String : Any] else { continue }
                guard let lisArrM = dictList["list"] as? [[String : Any]] else { return}
               let templeArrM = XM_GiftModel.mj_objectArray(withKeyValuesArray: lisArrM) as! [XM_GiftModel]
                giftArrM += templeArrM
            }
            let sortedGift = giftArrM.sorted { $0.coin! < $1.coin! }
            completion(sortedGift)
        }
    }
}
