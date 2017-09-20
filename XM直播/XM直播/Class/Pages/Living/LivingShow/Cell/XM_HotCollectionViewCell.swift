//
//  XM_HotCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/15.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_HotCollectionViewCell: XM_BaseCollectionViewCell {
    ///MARK: 主播头像
    fileprivate lazy var userImageView: UIImageView = {
        let userImageView = UIImageView.init()
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 20.0
        userImageView.contentMode = .scaleAspectFill
        return userImageView
    }()
    ///MARK: 主播姓名
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: nameLabel, textColor: UIColor.themeBlackColors(), fontSize: 14.0)
        return nameLabel
    }()
    ///MARK: vip 标识
    fileprivate lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView.init()
        vipImageView.image = UIImage.init(named: "NoVip")
        return vipImageView
    }()
    ///MARK: 定位信息
    fileprivate lazy var loactionLabel: UILabel = {
        let loactionLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: loactionLabel, textColor: UIColor.themeBlackColors(), fontSize: 12.0)
        return loactionLabel
    }()
    ///MARK: 在线观看人数
    fileprivate lazy var glanceLabel: UILabel = {
        let glanceLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: glanceLabel, textColor: UIColor.themeBlackColors(), fontSize: 12.0)
        return glanceLabel
    }()
    ///MARK:主播封面
    fileprivate lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView.init()
        coverImageView.layer.masksToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        return coverImageView
    }()
    /// xy_userinfo 主播标识
    fileprivate lazy var userinfoImageView: UIImageView = {
        let userinfoImageView = UIImageView.init()
       userinfoImageView.image = UIImage.init(named: "xy_userinfo_anchor_40x40_")
        return userinfoImageView
    }()
    
    ///MARK: 撩他
    fileprivate lazy var forceButton: UIButton = {
        let forceButton =  UIButton.init(type: UIButtonType.custom)
        forceButton.setImage(UIImage.init(named: "ic_near_alsayhi"), for: UIControlState.normal)
        forceButton.setImage(UIImage.init(named: "ic_near_sayhi"), for: UIControlState.selected)
        forceButton.addTarget(self, action: #selector(XM_HotCollectionViewCell.forceAction), for: .touchUpInside)
        return forceButton
    }()
    
    
    override  var showModelSetting: XM_LiveShowModel?{
        didSet{
            userImageView.sd_setImage(with: URL.init(string: (showModelSetting?.pic51)!), placeholderImage: UIImage.init(named: "home_pic_default"))
            coverImageView.sd_setImage(with: URL.init(string: (showModelSetting?.pic51)!), placeholderImage: UIImage.init(named: "home_pic_default"))
            nameLabel.text = showModelSetting?.name

            self.loactionLabel.text = "北京市石景山区"
            glanceLabel.text  =  getCurrentDate()
            if showModelSetting?.live == "1" {
                vipImageView.image = UIImage.init(named: "icon-VIP")
            }else{
                vipImageView.image = UIImage.init(named: "NoVip")
            }
        }
    }
    
    override var frame:CGRect{          ///重写Frame
        didSet {
            var newFrame = frame
            newFrame.origin.y += 15.0
            newFrame.size.height -= 15.0
            super.frame = newFrame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(forceButton)
        addSubview(userImageView)
        addSubview(vipImageView)
        addSubview(nameLabel)
        addSubview(loactionLabel)
        addSubview(glanceLabel)
        addSubview(coverImageView)
        addSubview(userinfoImageView)
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10.0)
            make.width.height.equalTo(40.0)
        }
        vipImageView.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(10.0)
            make.top.equalTo(userImageView.snp.top).offset(2.0)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(vipImageView.snp.right).offset(5.0)
            make.top.equalTo(userImageView.snp.top)
        }
        loactionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userImageView.snp.right).offset(10.0)
            make.top.equalTo(nameLabel.snp.bottom).offset(5.0)
        }
        glanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loactionLabel.snp.right).offset(10.0)
            make.top.equalTo(loactionLabel.snp.top)
        }
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(userImageView.snp.bottom).offset(10.0)
            make.bottom.equalTo(self)
        }
        userinfoImageView.snp.makeConstraints { (make) in
            make.right.equalTo(coverImageView.snp.right)
            make.top.equalTo(coverImageView.snp.top)
        }
        forceButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-20.0)
            make.top.equalTo(nameLabel.snp.top).offset(5.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension XM_HotCollectionViewCell{
    
    @objc fileprivate func forceAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("撩她")
    }
}
