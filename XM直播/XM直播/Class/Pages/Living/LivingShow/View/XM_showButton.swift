//
//  XM_showButton.swift
//  XM直播
//
//  Created by GDBank on 2017/8/15.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import Foundation

enum ButtonImagePosition: Int{
    case left  = 0
    case right
    case top
    case bottom
}

class XM_showButton: UIButton {
    
    /**
     * 重写标识 override
     **/
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect
    {
        return CGRect.init(x: (self.imageView?.frame.size.width)! + 5.0, y: 0, width: self.frame.size.width - (self.imageView?.frame.size.width)!, height: self.frame.size.height)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect
    {
        return CGRect(x: 0, y: 0, width:self.frame.size.height, height: self.frame.size.height)
    }
    
}


class XM_CustomButton: UIButton {
    
    
    var imagePosition: ButtonImagePosition {
        didSet{
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        self.imagePosition = .left
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //     UIEdgeInsetsMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat)
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageWidth = imageView?.image?.size.width,
            let imageHeight = imageView?.image?.size.height,
            let labelWidth =  titleLabel?.frame.width,
            let labelHeight = titleLabel?.frame.height else {
                return
        }
        switch imagePosition {
        case .left:
            return
        case .right:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)
            titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth)
        case .top:  ///(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight/2, labelWidth/2, labelHeight/2, -labelWidth/2)
            titleEdgeInsets = UIEdgeInsetsMake(imageHeight/2 + 5.0, -imageWidth/2, -imageHeight/2, imageWidth/2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsetsMake(labelHeight/2, -labelWidth/2, -labelHeight/2, labelWidth/2)
            titleEdgeInsets = UIEdgeInsetsMake(-imageHeight/2, imageWidth/2, imageHeight/2, -imageWidth/2)
            
        }
        
    }
}

class xm_sharedButton: UIControl {
    
    lazy var xm_shardImage: UIImageView = {
        let xm_shardImage = UIImageView.init()
        xm_shardImage.contentMode = .scaleAspectFit
        return xm_shardImage
    }()
    
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        xm_shardImage.image = UIImage.init(named: imageName)
        addSubview(xm_shardImage)
        
        xm_shardImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.height.equalTo(self.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
