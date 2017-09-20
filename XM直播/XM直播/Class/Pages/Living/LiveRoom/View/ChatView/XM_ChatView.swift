//
//  XM_ChatView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/21.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_ChatView: UIView {
    
    ///MARK: 输入框
    lazy var xm_chatTextView: UITextView = {
        let xm_chatTextView = UITextView.init()
        xm_chatTextView.layer.masksToBounds = true
        xm_chatTextView.layer.cornerRadius = 5
        xm_chatTextView.font = UIFont.systemFont(ofSize: 14.0)
        return xm_chatTextView
    }()
    ///MARK: 发送按钮
    fileprivate lazy var xm_chatSendButton: UIButton = {
        let xm_chatSendButton = UIButton.init(type: UIButtonType.custom)
        xm_chatSendButton.setTitle("发送", for: UIControlState.normal)
        xm_chatSendButton.backgroundColor = UIColor.init(red: 0/255.0, green: 127/255.0, blue: 255/255.0, alpha: 1.0)
        xm_chatSendButton.tintColor = UIColor.orange
        xm_chatSendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        xm_chatSendButton.addTarget(self, action: #selector(XM_ChatView.chatThings), for: .touchUpInside)
        xm_chatSendButton.tag = 200
        xm_chatSendButton.layer.masksToBounds = true
        xm_chatSendButton.layer.cornerRadius = 5.0
        return xm_chatSendButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(colorLiteralRed: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        
        addSubview(xm_chatTextView)
        addSubview(xm_chatSendButton)
        
        xm_chatTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5.0)
            make.left.equalTo(self).offset(10.0)
            make.right.equalTo(self).offset(-80.0)
            make.bottom.equalTo(self).offset(-5.0)
        }
        
        xm_chatSendButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10.0)
            make.top.equalTo(self).offset(5.0)
            make.left.equalTo(xm_chatTextView.snp.right).offset(10.0)
            make.height.equalTo(30.0)
        }
    }

    @objc fileprivate func chatThings(sender: UIButton) {
        switch sender.tag - 200 {
        case 0:
            self.xm_chatTextView.resignFirstResponder()             ///关闭键盘
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
