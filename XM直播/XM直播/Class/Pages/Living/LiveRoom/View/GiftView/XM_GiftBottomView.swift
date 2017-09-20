//
//  XM_GiftBottomView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/22.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

typealias xm_SendGifBlock = (_ sender: UIButton)->Void
class XM_GiftBottomView: UIView {
    
    ///MARK: 充值
    fileprivate lazy var chargeLabel: UILabel = {
        let chargeLabel = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: chargeLabel, textColor: UIColor.white, fontSize: 15.0)
        chargeLabel.text = "充值:" + "1000000"
        return chargeLabel
    }()
    ///MARK:vip标识 未充值非Vip 充值vip
    fileprivate lazy var vipIcon: UIImageView = {
        let vipIcon = UIImageView.init()
        vipIcon.image = UIImage.init(named: "icon-VIP")
        return vipIcon
    }()
    ///MARK: 进入充值标识
    fileprivate lazy  var enterIcon : UIImageView = {
        let enterIcon = UIImageView.init()
        enterIcon.image = UIImage.init(named: "icon_enter")
        return enterIcon
    }()
    ///MARK: 发送礼物
    fileprivate lazy var sendButton: UIButton = {
        let sendButton = UIButton.init(type: UIButtonType.custom)
        sendButton.setTitle("赠送礼物", for: UIControlState.normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        sendButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        sendButton.setTitleColor(UIColor.orange, for: UIControlState.highlighted)
        sendButton.backgroundColor = UIColor.orange
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 5.0
        sendButton.addTarget(self, action: #selector(XM_GiftBottomView.sendGift), for: .touchUpInside)
        return sendButton
    }()
    
    var xm_sendGifBlock: xm_SendGifBlock?
    
    ///MARK: 金币剩余
    var giftModel: XM_GiftModel?{
        didSet{
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let linView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kMainBoundsWidth, height: 0.5))
        linView.backgroundColor = UIColor.white
        
        addSubview(linView)
        addSubview(chargeLabel)
        addSubview(vipIcon)
        addSubview(enterIcon)
        addSubview(sendButton)
        
        chargeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.0)
            make.centerY.equalTo(self.snp.centerY)
        }
        vipIcon.snp.makeConstraints { (make) in
            make.left.equalTo(chargeLabel.snp.right).offset(10.0)
            make.centerY.equalTo(chargeLabel.snp.centerY)
        }
        enterIcon.snp.makeConstraints { (make) in
            make.left.equalTo(vipIcon.snp.right).offset(10.0)
            make.centerY.equalTo(vipIcon.snp.centerY)
        }
        sendButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10.0)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(80.0)
        }
    }
    
    @objc fileprivate func sendGift(sender:UIButton) {
        if (self.xm_sendGifBlock != nil) {
            self.xm_sendGifBlock!(_:sender)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
