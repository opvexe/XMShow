//
//  XM_ShowCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/14.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class XM_ShowCollectionViewCell: XM_BaseCollectionViewCell {
    ///MARK: 主播封面
    fileprivate lazy var xm_AnchorImageView: UIImageView = {
        let  xm_AnchorImageView = UIImageView.init()
        xm_AnchorImageView.layer.masksToBounds = true
        xm_AnchorImageView.layer.cornerRadius = 5.0
        xm_AnchorImageView.contentMode = .scaleAspectFill
        return xm_AnchorImageView
    }()
    ///MARK: 主播名字
    fileprivate lazy var xm_AnchorName: UILabel = {
        let xm_AnchorName = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: xm_AnchorName, textColor: UIColor.brown, fontSize: 12.0)
        return xm_AnchorName
    }()
    ///MARK:主播房名
    fileprivate  lazy var xm_AnchorRoomId:UILabel = {
        let xm_AnchorRoomId = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: xm_AnchorRoomId, textColor: UIColor.brown, fontSize: 8.0)
        return xm_AnchorRoomId
    }()
    ///MARK: 观看人数
    fileprivate lazy var xm_AnchorFocus: XM_showButton = {
        let xm_AnchorFocus = XM_showButton.init(type: UIButtonType.custom)
        xm_AnchorFocus.setImage(UIImage.init(named: "Icon_pic_look"), for: .normal)
        xm_AnchorFocus.setTitleColor(UIColor.brown, for: .normal)
        xm_AnchorFocus.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        return xm_AnchorFocus
    }()
    ///MARK: 是否在直播标识
    fileprivate lazy var xm_livingImageView: UIImageView = {
        let xm_livingImageView  = UIImageView.init()
        xm_livingImageView.image = UIImage.init(named: "home_icon_live")
        return xm_livingImageView
    }()
    
    override var showModelSetting: XM_LiveShowModel?{
        didSet{
            xm_AnchorImageView.sd_setImage(with: URL.init(string: (showModelSetting?.pic51)!), placeholderImage: UIImage.init(named: "home_pic_default"))
            xm_AnchorRoomId.text = NSString.init(format: "房间号:%@", (showModelSetting?.roomid)!) as String
            xm_AnchorName.text   = showModelSetting?.name
            let numer  = Int((showModelSetting?.focus)!)
            xm_AnchorFocus.setTitle(xm_NumberWithString(count:numer!) as String, for: .normal)
            if showModelSetting?.live == "1" {
                xm_livingImageView.image = UIImage.init(named: "home-pic-live")
            }else{
                xm_livingImageView.image = UIImage.init(named: "home_icon_live")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(xm_AnchorImageView)
        xm_AnchorImageView.addSubview(xm_livingImageView)
        addSubview(xm_AnchorName)
        addSubview(xm_AnchorRoomId)
        addSubview(xm_AnchorFocus)
        
        xm_AnchorImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(120)
        }
        xm_livingImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10.0)
            make.top.equalTo(self).offset(10.0)
        }
        xm_AnchorRoomId.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(10.0)
        }
        xm_AnchorName.snp.makeConstraints { (make) in
            make.top.equalTo(xm_AnchorImageView.snp.bottom).offset(10.0)
            make.left.equalTo(self)
        }
        xm_AnchorFocus.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5.0)
            make.top.equalTo(xm_AnchorName.snp.top)
            make.height.equalTo(15.0)
            make.width.equalTo(55.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
