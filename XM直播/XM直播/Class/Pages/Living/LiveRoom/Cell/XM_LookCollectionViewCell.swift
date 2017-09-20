//
//  XM_LookCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/18.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SDWebImage

class XM_LookCollectionViewCell: XM_BaseCollectionViewCell {
    ///MARK: 观众人数
    fileprivate lazy var xm_audienceImageIcon: UIImageView = {
        let xm_audienceImageIcon = UIImageView.init(frame: self.bounds)
        xm_audienceImageIcon.image = UIImage.init(named: "avatar_default_40x40_")
        xm_audienceImageIcon.layer.masksToBounds = true
        xm_audienceImageIcon.layer.cornerRadius = 15.0
        return xm_audienceImageIcon
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(xm_audienceImageIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
