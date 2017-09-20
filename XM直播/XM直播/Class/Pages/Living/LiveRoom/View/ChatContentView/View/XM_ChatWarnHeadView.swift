//
//  XM_ChatWarnHeadView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/29.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_ChatWarnHeadView: UIView {

    fileprivate lazy var xm_warnLabel: UILabel = {
        let xm_warnLabel = UILabel.init()
        UILabel.setupMultiLineLabel(multiLabel: xm_warnLabel, textColor: UIColor.orange, fontSize: 14.0)
        return xm_warnLabel
    }()
    
     init(frame: CGRect, warnTitle: String) {
        super.init(frame: frame)
        xm_warnLabel.text = warnTitle
        let heights = xm_GetTextHeigh(textStr: xm_warnLabel.text!, font: UIFont.init(name: "PingFangSC-Light", size: 14.0)!, width: kMainBoundsWidth*0.75 - 20.0)
        self.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: heights + 20.0)
        addSubview(xm_warnLabel)
        xm_warnLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(10.0)
            make.right.bottom.equalTo(-10.0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
