//
//  XM_ShareCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/29.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_ShareCollectionViewCell: UICollectionViewCell {
    ///MARK: 分享图片
     lazy var xm_ShareImageView: UIImageView = {
        let xm_ShareImageView = UIImageView.init()
        return xm_ShareImageView
    }()
    ///MARK: 分享文字
     lazy var xm_ShareLabel: UILabel = {
        let xm_ShareLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: xm_ShareLabel, textColor: UIColor.themeLightGrayColors(), fontSize: 12.0)
        return xm_ShareLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        addSubview(xm_ShareImageView)
        addSubview(xm_ShareLabel)
        
        xm_ShareImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10.0)
            make.width.height.equalTo(30.0)
        }
        xm_ShareLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(xm_ShareImageView.snp.bottom).offset(10.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
