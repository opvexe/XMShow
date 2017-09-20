//
//  XM_ShareView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/21.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_ShareView: UIView {
    ///MARK: 背景视图
    var _window             :UIWindow!
    var _shareViewBackground: UIView!
    ///MARK: 属性数据
    var imageArray: [String]?
    var titleArray: [String]?
    ///MARK: 九宫格布局
    fileprivate lazy var XM_ShareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let XM_ShareCollectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: layout)
        XM_ShareCollectionView.showsHorizontalScrollIndicator = false
        XM_ShareCollectionView.showsVerticalScrollIndicator  = false
        XM_ShareCollectionView.isScrollEnabled = false  ///MARK: 不滚动
        XM_ShareCollectionView.dataSource = self
        XM_ShareCollectionView.delegate = self
        XM_ShareCollectionView.register(XM_ShareCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_ShareCollectionViewCell.self))
        XM_ShareCollectionView.backgroundColor = UIColor.clear
        return XM_ShareCollectionView
    }()
    ///MARK: 取消按钮
    fileprivate lazy var XM_CancelButton: UIButton = {
        let XM_CancelButton = UIButton.init(type: UIButtonType.custom)
        XM_CancelButton.setTitle("取消", for: UIControlState.normal)
        XM_CancelButton.setTitleColor(UIColor.themeLightGrayColors(), for: UIControlState.normal)
        XM_CancelButton.backgroundColor = UIColor.clear
        XM_CancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        XM_CancelButton.titleLabel?.textAlignment = NSTextAlignment.center
        XM_CancelButton.addTarget(self, action: #selector(XM_ShareView.hidden), for: .touchUpInside)
        return XM_CancelButton
    }()
    
    init(frame: CGRect,imageArray: NSArray,titleArray: NSArray) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let row = imageArray.count / 4 + 1
        self.frame =  CGRect.init(x: 0, y: kMainBoundsHeight, width: kMainBoundsWidth, height: 40.0 + CGFloat(row)*40.0)
        self.imageArray = imageArray as? [String]
        self.titleArray = titleArray as? [String]
        
        _shareViewBackground = UIView.init(frame: UIScreen.main.bounds)
        _shareViewBackground.backgroundColor = UIColor.clear
        _shareViewBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(XM_ShareView.hidden)))
        
        addSubview(XM_ShareCollectionView)
        addSubview(XM_CancelButton)
        XM_ShareCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self).offset(-40.0)
        }
        XM_CancelButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(XM_ShareCollectionView.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XM_ShareView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (self.imageArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_ShareCollectionViewCell.self), for: indexPath) as?XM_ShareCollectionViewCell
        cell?.xm_ShareImageView.image = UIImage.init(named: (self.imageArray?[indexPath.row])!)
        cell?.xm_ShareLabel.text = self.titleArray?[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: kMainBoundsWidth/4, height:40.0)
    }
    
    ///MARK: 点击分享
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        hidden()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)       ///距离两边距left right  top 距离区头 botton 距离区尾
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {   // 设置最小列间距，也就是左行与右一行的中间最小间隔
        return 0
    }
}


extension XM_ShareView {
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
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.2)
            self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - self.frame.height, width: UIScreen.main.bounds.width, height: self.frame.height)
        })
    }
    
    @objc open func hidden() {          ///MARK: 隐藏   方法公开
        UIView.animate(withDuration: 0.2, animations: {
            self._shareViewBackground.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            self.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.frame.height)
        }) { (finished) in
            self._window = nil
        }
    }
}
