//
//  XMProfileModel.swift
//  XM直播
//
//  Created by GDBank on 2017/8/11.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
enum XM_TableViewCellType: Int {
    case XM_TableViewCellTypeGift = 1
    case XM_TableViewCellTypeAccount = 2
}

class XMProfileModel: NSObject {
    var title: String?
    var imageProfile: String?
    var ClsName: String?
    var CellType: XM_TableViewCellType?
    var tableHeadHeights: CGFloat?
    
}
