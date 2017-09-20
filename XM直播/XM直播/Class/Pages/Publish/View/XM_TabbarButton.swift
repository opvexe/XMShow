//
//  XM_TabbarButton.swift
//  XM直播
//
//  Created by GDBank on 2017/9/6.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

let ICONHEIGHT: CGFloat = 55.0
let TITLEHEIGHT: CGFloat = 20.0


class XM_TabbarButton: UIButton {

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect.init(x: 0, y: (contentRect.size.height - ICONHEIGHT - TITLEHEIGHT)/2, width: contentRect.width, height: ICONHEIGHT)
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect.init(x: 0, y: contentRect.size.height - TITLEHEIGHT, width: contentRect.width, height: TITLEHEIGHT)
    }
}
