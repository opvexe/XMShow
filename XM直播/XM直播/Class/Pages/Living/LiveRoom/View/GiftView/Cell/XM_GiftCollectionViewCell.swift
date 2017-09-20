//
//  XM_GiftCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/22.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SDWebImage

class XM_GiftCollectionViewCell: UICollectionViewCell {
    
    ///MARK: 礼物
    fileprivate lazy var giftImageView: UIImageView = {
        let giftImageView  = UIImageView.init()
        giftImageView.contentMode = .scaleAspectFill
        return giftImageView
    }()
    ///MARK: 礼物名字
    fileprivate lazy var giftName: UILabel = {
        let giftName = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: giftName, textColor: UIColor.white, fontSize: 10.0)
        return giftName
    }()
    ///MARK: 金币
    fileprivate lazy var giftGold: UILabel = {
        let giftGold = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: giftGold, textColor: UIColor.white, fontSize: 10.0)
        return giftGold
    }()
    
    var  linView = UIView.init()
    
    
    var giftModel: XM_GiftModel?{
        didSet{
            
            linView.isHidden = true
            if (giftModel?.xm_isSelected)! {            ////MARK: 通过显隐性控制
                linView.isHidden = false
            }else{
                linView.isHidden = true
            }
            
            giftImageView.sd_setImage(with: URL.init(string: (giftModel?.img2)!), placeholderImage: UIImage.init(named: "ico_gift"))
            giftName.text = giftModel?.subject
            giftGold.text = "金币: " + (giftModel?.coin)!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        linView.layer.masksToBounds = true
        linView.layer.borderColor = UIColor.orange.cgColor
        linView.layer.borderWidth = 2.0
        linView.backgroundColor = UIColor.clear
        linView.layer.cornerRadius = 5.0
        linView.isHidden = true
        
        addSubview(linView)
        addSubview(giftImageView)
        addSubview(giftName)
        addSubview(giftGold)
        
        linView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        giftImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(5.0)
            make.width.height.equalTo(40.0)
        }
        giftName.snp.makeConstraints { (make) in
            make.top.equalTo(giftImageView.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
        giftGold.snp.makeConstraints { (make) in
            make.top.equalTo(giftName.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
