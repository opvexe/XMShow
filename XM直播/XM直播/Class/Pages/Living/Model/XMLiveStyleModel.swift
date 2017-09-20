//
//  XMLiveStyleModel.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XMLiveStyleModel: NSObject {

    var title: String?      ///标题
    var type : Int = 0        ///类型

}


class XM_LiveShowModel: NSObject {
    
    var pic51 :String?
    var uid: String?
    var roomid: String?
    var name: String?
    var live: String = ""
    var push: String = ""
    var focus: String = "0"
    var charge:Int = 0
    var mic: Int = 0
    var weeklyStar: Int = 0
    var yearParty: Int = 0
    var gameName: String?
    var gameIcon: String?
    var gameId: String?
}
