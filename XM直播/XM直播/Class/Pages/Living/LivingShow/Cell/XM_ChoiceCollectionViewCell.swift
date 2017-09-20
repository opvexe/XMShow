//
//  XM_ChoiceCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/15.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_ChoiceCollectionViewCell: XM_BaseCollectionViewCell {
    ///MARK: 背景视图
    fileprivate lazy var bg_choiceView: UIView = {
        let bg_choiceView = UIView.init()
        bg_choiceView.layer.masksToBounds = true
        bg_choiceView.layer.cornerRadius = 5.0
        return bg_choiceView
    }()
    
    ///MARK: 主播封面
    fileprivate lazy var xm_AnchorImageView: UIImageView = {
        let  xm_AnchorImageView = UIImageView.init()
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
        UILabel.setupSingleLabel(styleLabel: xm_AnchorRoomId, textColor: UIColor.brown, fontSize: 12.0)
        return xm_AnchorRoomId
    }()
    ///MARK: 定位信息
    fileprivate lazy var loactionLabel: UILabel = {
        let loactionLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: loactionLabel, textColor: UIColor.brown, fontSize: 12.0)
        return loactionLabel
    }()
    ///MARK: 观看人数
    fileprivate lazy var lookLabel: UILabel = {
        let lookLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: lookLabel, textColor: UIColor.brown, fontSize: 12.0)
        return lookLabel
    }()
 
    override  var showModelSetting: XM_LiveShowModel?{
        didSet{
            xm_AnchorImageView.sd_setImage(with: URL.init(string: (showModelSetting?.pic51)!), placeholderImage: UIImage.init(named: "home_pic_default"))
            xm_AnchorRoomId.text = "房间号: " + (showModelSetting?.roomid)!
            loactionLabel.text = "北京市"
              xm_AnchorName.text = showModelSetting?.name
            let numer  = Int((showModelSetting?.focus)!)
            lookLabel.text = xm_NumberWithString(count:numer!) as String
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        
        addSubview(bg_choiceView)
        bg_choiceView.addSubview(xm_AnchorImageView)
        bg_choiceView.addSubview(xm_AnchorName)
        bg_choiceView.addSubview(xm_AnchorRoomId)
        bg_choiceView.addSubview(loactionLabel)
        bg_choiceView.addSubview(lookLabel)
        
        bg_choiceView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        xm_AnchorImageView.snp.makeConstraints { (make) in
            make.left.equalTo(bg_choiceView.snp.left)
            make.right.equalTo(bg_choiceView.snp.right)
            make.top.equalTo(bg_choiceView.snp.top)
            make.bottom.equalTo(bg_choiceView.snp.bottom).offset(-20.0)
        }
        xm_AnchorRoomId.snp.makeConstraints { (make) in
            make.left.top.equalTo(bg_choiceView).offset(10.0)
        }
        loactionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bg_choiceView.snp.right).offset(-5.0)
            make.top.equalTo(bg_choiceView.snp.top).offset(10.0)
        }
        xm_AnchorName.snp.makeConstraints { (make) in
            make.left.equalTo(bg_choiceView.snp.left).offset(10.0)
            make.top.equalTo(xm_AnchorImageView.snp.bottom).offset(3.0)
        }
        lookLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bg_choiceView.snp.right).offset(-10.0)
            make.top.equalTo(xm_AnchorImageView.snp.bottom).offset(3.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
