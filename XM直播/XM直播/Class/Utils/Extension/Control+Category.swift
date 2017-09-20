//
//  Control+Category.swift
//  XM直播
//
//  Created by GDBank on 2017/8/11.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import Foundation
import UIKit

///Mark: 设置button位置
enum xm_ButtonImagePosition : Int{
    case PositionTop = 0
    case Positionleft
    case PositionBottom
    case PositionRight
}

/**
 *  枚举和结构体的静态方法使用的关键字是static
 *  类的静态方法使用的关键字是class。
 **/
extension UILabel {
 
    class func setupSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.center
        styleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        styleLabel.sizeToFit()
    }

    class func setupMultiLineLabel(multiLabel: UILabel,textColor:UIColor ,fontSize:CGFloat){
        multiLabel.textColor = textColor
        multiLabel.textAlignment = NSTextAlignment.left
        multiLabel.numberOfLines = 0
        multiLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        multiLabel.sizeToFit()
    }
    
    class func setSystemSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.center
        styleLabel.font = UIFont.systemFont(ofSize: fontSize)
        styleLabel.sizeToFit()
    }
    
    class func setBoldSystemSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.center
        styleLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        styleLabel.sizeToFit()
    }
}

extension UIButton {
    
    @objc func set(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}


