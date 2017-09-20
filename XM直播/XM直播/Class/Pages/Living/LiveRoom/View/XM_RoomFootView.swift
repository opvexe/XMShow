//
//  XM_RoomFootView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/18.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit


typealias xm_shardGifBlock = (_ tag: NSInteger, _ sender: UIButton)->Void
class XM_RoomFootView: UIView {

    
    var xm_shardGifBlock: xm_shardGifBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.backgroundColor = UIColor.clear
        
        let ArrM = ["room_btn_chat","room_btn_gift","menu_btn_share","room_btn_qfstar"]
        for i in 0..<ArrM.count {
            let kWidth = Double(kMainBoundsWidth)
            let width = kWidth/Double(ArrM.count)
            let height = 40.0
            let xm_X = Double(i)*width
            let buton = xm_sharedButton.init(frame: CGRect.init(x: xm_X, y: 10, width: width, height: height - 20.0), imageName: ArrM[i])
            buton.addTarget(self, action: #selector(XM_RoomFootView.dothings), for: .touchUpInside)
            buton.tag = 100 + i
            addSubview(buton)
        }
    }

   @objc fileprivate func dothings(sender: UIButton) {
    if (self.xm_shardGifBlock != nil) {
        self.xm_shardGifBlock!(_ : sender.tag,sender)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
