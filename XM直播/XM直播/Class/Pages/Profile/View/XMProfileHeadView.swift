//
//  XMProfileHeadView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/11.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XMProfileHeadView: UIView {

    fileprivate lazy var xm_bgImageView: UIImageView = {
        let xm_bgImageView = UIImageView.init()
        xm_bgImageView.image = UIImage(named: "setting_bg_375x667_")
        xm_bgImageView.contentMode = .scaleAspectFill
        xm_bgImageView.layer.masksToBounds = true
        return xm_bgImageView
    }()
    
    fileprivate lazy var profileImageView : UIImageView = {
        let profileImageView = UIImageView.init()
        profileImageView.image = UIImage(named: "setting_bg_375x667_")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius  = 40
        profileImageView.layer.borderWidth   = 2.0
        profileImageView.layer.borderColor   = UIColor.white.cgColor
        profileImageView.layer.rasterizationScale = UIScreen.main.scale     ///缓存图片
        profileImageView.layer.shouldRasterize = true
        return profileImageView
    }()

    override init(frame: CGRect) {
       super.init(frame: frame)
        
        addSubview(xm_bgImageView)
        addSubview(profileImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let space: CGFloat = (self.frame.size.width - kMainBoundsWidth) * 0.5
        xm_bgImageView.frame = CGRect(x: space, y: 0, width: kMainBoundsWidth, height: self.frame.size.height)
        
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(80)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

