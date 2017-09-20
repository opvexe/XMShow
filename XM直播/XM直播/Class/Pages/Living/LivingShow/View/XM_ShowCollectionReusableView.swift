//
//  XM_ShowCollectionReusableView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/14.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import MJExtension

///MARK: 点击游戏按钮代理行为
protocol xm_ShowGameDelegate: NSObjectProtocol{
    func xm_showGameClickAtIndex(index: Int)
}
class XM_ShowCollectionReusableView: UICollectionReusableView {
    
    fileprivate var xm_RollShowView = XM_RollView.init(Y: 0, H: 208.0)
    fileprivate var modelArr = [XM_RollModel]()
    weak var xm_delegate: xm_ShowGameDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let souceRoll = [
            ["pic_url":"https://file.qf.56.com/p/group2/M01/7A/EB/MTAuMTAuODguODE=/MTAwMTA2XzE1MDA5Nzg5ODU1NjE=/cut@m=crop,x=0,y=0,w=640,h=640_cut@m=resize,w=510,h=510.jpg"],
            ["pic_url":"https://file.qf.56.com/p/group3/M01/79/CC/MTAuMTAuODguODM=/MTAwMTA2XzE0OTkyMjUxMTA5NTA=/cut@m=crop,x=0,y=0,w=864,h=864_cut@m=resize,w=510,h=510.jpg"],
            ["pic_url":"https://file.qf.56.com/p/group3/M06/86/C5/MTAuMTAuODguODQ=/MTAwMTA2XzE1MDE5MTI2Njc5ODQ=/cut@m=crop,x=0,y=0,w=510,h=510_cut@m=resize,w=640,h=640.png"],
            ["pic_url":"https://file.qf.56.com/p/group2/M01/85/50/MTAuMTAuODguODI=/MTAwMTA2XzE1MDE4MTAwODY1NjA=/cut@m=crop,x=0,y=0,w=963,h=963_cut@m=resize,w=640,h=640.jpg"],
            ["pic_url":"https://file.qf.56.com/p/group3/M09/84/9E/MTAuMTAuODguODQ=/MTAwMTA2XzE1MDE3NDg4NjMzMjY=/cut@m=crop,x=0,y=0,w=510,h=510_cut@m=resize,w=640,h=640.png"]
        ]
        
        modelArr = XM_RollModel.mj_objectArray(withKeyValuesArray: souceRoll) as! [XM_RollModel]
        xm_RollShowView.carouselModelArr = modelArr
        addSubview(xm_RollShowView)
        
        let imageIconRoll = ["avatar_default_40x40_","avatar_default_40x40_","avatar_default_40x40_","avatar_default_40x40_"]
        let titleRoll = ["英雄联盟","王者荣耀","LPL","户外直播"]
        
        for index in 0..<titleRoll.count {
            let button = XM_TabbarButton.init(type: UIButtonType.custom)
            button.setImage(UIImage.init(named: imageIconRoll[index]), for: UIControlState.normal)
            button.setTitle(titleRoll[index], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(UIColor.brown, for: UIControlState.normal)
            button.tag = 1000 + index
            button.set(image: UIImage(named:imageIconRoll[index]), title: titleRoll[index], titlePosition: .bottom,
                       additionalSpacing: 10.0, state: .normal)
            button.addTarget(self, action: #selector(XM_ShowCollectionReusableView.dothings), for: .touchUpInside)
            let kWidth = Double(kMainBoundsWidth)
            let width = kWidth/Double(titleRoll.count)
            let height = 80.0
            let xm_X = Double(index)*width
            button.frame = CGRect.init(x: xm_X, y: 208, width: width, height: height)
            addSubview(button)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XM_ShowCollectionReusableView{
    @objc fileprivate  func dothings(sender: UIButton) {
        guard (xm_delegate?.xm_showGameClickAtIndex(index: )) != nil  else { return}
        xm_delegate?.xm_showGameClickAtIndex(index: sender.tag)
    }
}
