//
//  XM_RollCollectionViewCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/16.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SDWebImage

class XM_RollCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var newimageView = UIImageView()
    
    
    var carouselModel : XM_RollModel? {
        didSet {
            imageView.sd_setImage(with: URL(string:(carouselModel?.pic_url)!), placeholderImage: UIImage(named: "home_pic_default"))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        newimageView.image = UIImage.init(named: "new_22x22_")
        newimageView.contentMode = .scaleAspectFill
        addSubview(newimageView)
        newimageView.snp.makeConstraints { (make) in
            make.top.right.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


