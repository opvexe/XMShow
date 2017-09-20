//
//  XMProfileTableViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/11.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SnapKit

class XMProfileTableViewCell: UITableViewCell {
    
    fileprivate var leftImageView = UIImageView.init()
    fileprivate var titleLabel = UILabel.init()
    fileprivate var rightImageView = UIImageView.init()
    
    var ModelSetting :XMProfileModel?{
         didSet{
            leftImageView.image = UIImage(named:(ModelSetting?.imageProfile)!)
            titleLabel.text     = ModelSetting?.title
            rightImageView.image = UIImage(named:("icon-arrow"))
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        xm_addSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///创建布局
extension XMProfileTableViewCell{
    
    fileprivate  func xm_addSubView()  {
        
        leftImageView.contentMode = UIViewContentMode.center
        rightImageView.contentMode = UIViewContentMode.center
        UILabel.setupSingleLabel(styleLabel: titleLabel ,textColor:UIColor.black,fontSize:13.0)
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)
        
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(20)
            make.left.equalTo(self).offset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(20)
        }
    }
}
