//
//  XM_BaseCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/15.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_BaseCollectionViewCell: UICollectionViewCell {
    
    /// 模型数据赋值
    var showModelSetting: XM_LiveShowModel?{
        didSet{
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
