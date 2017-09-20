//
//  XM_PublishView.swift
//  XM直播
//
//  Created by GDBank on 2017/9/5.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

typealias clickPublishBlock =  (_ tag: NSInteger, _ sender: UIButton)->Void
class XM_PublishView: UIView {
    
    var _window             :UIWindow!
    var _shareViewBackground: UIView!
    var xm_PublishBlock: clickPublishBlock?
    
    init(frame: CGRect,imageArr: [String], titleArr: [String]) {
        super.init(frame:frame)
        ///MARK: 背景视图
        _shareViewBackground = UIView.init(frame: UIScreen.main.bounds)
        _shareViewBackground.backgroundColor = UIColor.white
        _shareViewBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(XM_PublishView.hidden)))
        ///底部视图
        for index in 0..<Int(imageArr.count) {
            let btn = XM_TabbarButton.init(type: UIButtonType.custom)
            btn.setImage(UIImage.init(named: imageArr[index]), for: UIControlState.normal)
            btn.setTitle(titleArr[index], for: UIControlState.normal)
            btn.setTitleColor(UIColor.themeLightGrayColors(), for: UIControlState.normal)
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            btn.addTarget(self, action: #selector(XM_PublishView.didClickBtn), for: .touchUpInside)
            btn.addTarget(self, action: #selector(XM_PublishView.didTouchBtn), for: .touchDown) ///MARK: 手按下的那一刻
            btn.addTarget(self, action: #selector(XM_PublishView.didCancelBtn), for: .touchDragInside) ///MARK: 手离开那一刻
            _shareViewBackground.addSubview(btn)
            
            let X = UIScreen.main.bounds.width/2 - 100.0
            let Y = UIScreen.main.bounds.height - 200.0
            let W: CGFloat = 55.0
            let H: CGFloat = 80.0
            if index == 2 {
                btn.frame = CGRect.init(x: UIScreen.main.bounds.width/2 - W/2, y: Y + H + 20.0, width: W, height: H)
                btn.tag = 100 + index
            }else{
                btn.frame = CGRect.init(x: X + CGFloat(index) * 3.0*W, y: Y, width: W, height: H)
                btn.tag = 100 + index
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XM_PublishView{
    ///MARK: 点击事件
    @objc fileprivate func didClickBtn(sender: UIButton) {
         hidden()
        if (self.xm_PublishBlock != nil) {
            self.xm_PublishBlock!(_: sender.tag, sender)
        }
    }
    @objc fileprivate func didTouchBtn(sender: UIButton) {
        sender.scalingWithTime(time: 0.15, scal: 1.2)
    }
    @objc fileprivate func didCancelBtn(sender: UIButton) {
        sender.scalingWithTime(time: 0.15, scal: 1.0)
    }
}

extension XM_PublishView {
    open func show() {    ///MARK: 显示 方法公开
        _window = UIWindow.init(frame: UIScreen.main.bounds)
        _window.windowLevel = UIWindowLevelAlert+1
        _window.backgroundColor = UIColor.clear
        _window.isHidden = true
        _window.isUserInteractionEnabled = true 
        _window.addSubview(_shareViewBackground)
        _window.addSubview(self)
        
        _window.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.alpha = 0.9
            self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - self.frame.height, width: UIScreen.main.bounds.width, height: self.frame.height)
        })
    }
    
    @objc open func hidden() {          ///MARK: 隐藏   方法公开
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.alpha = 0.0
            self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.frame.height)
        }) { (finished) in
            self._window = nil
        }
    }
}
