//
//  XM_RoomHeadView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/17.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SDWebImage

typealias xm_RoomBlock = (_ tag: NSInteger)->Void         ///MARK: 闭包
class XM_RoomHeadView: UIView {
    ///MARK: 返回按钮
    fileprivate lazy var xm_backButton: UIButton = {
        let xm_backButton = UIButton.init(type: UIButtonType.custom)
        xm_backButton.setImage(UIImage.init(named: "icon-cancle"), for: UIControlState.normal)
        xm_backButton.setImage(UIImage.init(named: "icon-cancle"), for: UIControlState.highlighted)
        xm_backButton.addTarget(self, action: #selector(XM_RoomHeadView.dothings), for: .touchUpInside)
        xm_backButton.tag = 1001
        xm_backButton.backgroundColor = UIColor.clear
        return xm_backButton
    }()
    ///MARK:主播头像
    fileprivate lazy var xm_anchorIcon: UIImageView = {
        let xm_anchorIcon  = UIImageView.init()
        xm_anchorIcon.layer.masksToBounds = true
        xm_anchorIcon.layer.cornerRadius = 20.0
        xm_anchorIcon.contentMode = .scaleAspectFill
        xm_anchorIcon.layer.borderColor = UIColor.white.cgColor
        xm_anchorIcon.layer.borderWidth = 1.0
        return xm_anchorIcon
    }()
    ///MARK:主播姓名
    fileprivate lazy var xm_anchorName: UILabel = {
        let xm_anchorName = UILabel.init()
        xm_anchorName.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        UILabel.setupSingleLabel(styleLabel: xm_anchorName, textColor: UIColor.white, fontSize: 13.0)
        return xm_anchorName
    }()
    ///MARK: 主播头部文字背景视图
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius  = 20.0
        return bgView
    }()
    ///MARK:在线人数
    fileprivate lazy var xm_onlinePeople: UILabel = {
        let xm_onlinePeople = UILabel.init()
        UILabel.setupSingleLabel(styleLabel: xm_onlinePeople, textColor: UIColor.white, fontSize:12.0)
        return xm_onlinePeople
    }()
    ///MARK: 主播皇冠
    fileprivate lazy var xm_anchorHG: UIImageView = {
        let xm_anchorHG = UIImageView.init()
        xm_anchorHG.image = UIImage.init(named: "icon-huangguan")
        return xm_anchorHG
    }()
    ///MARK: 观看人数瀑布流
    fileprivate lazy var xm_lookLiveingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let xm_lookLiveingCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        xm_lookLiveingCollectionView.showsHorizontalScrollIndicator = false
        xm_lookLiveingCollectionView.showsVerticalScrollIndicator  = false
        xm_lookLiveingCollectionView.dataSource = self
        xm_lookLiveingCollectionView.delegate = self
        xm_lookLiveingCollectionView.register(XM_LookCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_LookCollectionViewCell.self))
        xm_lookLiveingCollectionView.backgroundColor = UIColor.clear
        return xm_lookLiveingCollectionView
    }()
    ///MARK: 已认证
    fileprivate lazy var xm_ProfileAuthen: UIImageView = {
        let xm_ProfileAuthen = UIImageView.init(image: UIImage.init(named: "img-yirenz"))
        return xm_ProfileAuthen
    }()
    ///MARK: +关注
    fileprivate lazy var xm_foceButtton: UIButton  = {
        let xm_foceButtton = UIButton.init(type: UIButtonType.custom)
        xm_foceButtton.setTitle("+ 关注", for: UIControlState.normal)
        xm_foceButtton.setTitle("已关注", for: UIControlState.selected)
        xm_foceButtton.setTitleColor(UIColor.green, for: UIControlState.normal)
        xm_foceButtton.setTitleColor(UIColor.white, for: UIControlState.selected)
        xm_foceButtton.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.white), for: UIControlState.normal)
        xm_foceButtton.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.green), for: UIControlState.selected)
        xm_foceButtton.titleLabel?.textAlignment = NSTextAlignment.right
        xm_foceButtton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        xm_foceButtton.layer.masksToBounds = true
        xm_foceButtton.layer.cornerRadius = 15.0
        xm_foceButtton.tag = 1002
        xm_foceButtton.addTarget(self, action: #selector(XM_RoomHeadView.dothings), for: .touchUpInside)
        return xm_foceButtton
    }()
    ///MARK: 主播送礼排行榜
    fileprivate lazy var xm_RinkMonthButton: UIButton = {
        let xm_RinkMonthButton = UIButton.init(type: UIButtonType.custom)
        xm_RinkMonthButton.setImage(UIImage.init(named: "xy_button_giftweekrank_99x22_"), for: UIControlState.normal)
        xm_RinkMonthButton.setImage(UIImage.init(named: "xy_button_giftweekrank_99x22_"), for: UIControlState.highlighted)
        xm_RinkMonthButton.tag = 1003
        xm_RinkMonthButton.addTarget(self, action: #selector(XM_RoomHeadView.dothings), for: .touchUpInside)
        return xm_RinkMonthButton
    }()
    
    ///xy_starvalue
    fileprivate lazy var xm_startImageView: UIImageView = {
        let xm_startImageView = UIImageView.init()
        xm_startImageView.image = UIImage.init(named: "xy_starvalue_bg_86x22_")
        return xm_startImageView
    }()
    ///MARK: 竞猜
    fileprivate lazy var xm_pxyMoneyButton: UIButton = {
        let xm_pxyMoneyButton = UIButton.init(type: UIButtonType.custom)
        xm_pxyMoneyButton.setImage(UIImage.init(named: "pxyMoneyBegin_83x83_"), for: UIControlState.normal)
        xm_pxyMoneyButton.setImage(UIImage.init(named: "pxyMoneyBegin_83x83_"), for: UIControlState.highlighted)
        xm_pxyMoneyButton.tag = 1004
        xm_pxyMoneyButton.addTarget(self, action: #selector(XM_RoomHeadView.dothings), for: .touchUpInside)
        return xm_pxyMoneyButton
    }()
    ///MARK: 设置Model
    var xm_roomModel: XM_LiveShowModel?{
        didSet{
            xm_anchorIcon.sd_setImage(with: URL.init(string: (xm_roomModel?.pic51)!), placeholderImage: UIImage.init(named: "avatar"))
            xm_anchorName.text = xm_roomModel?.name
            xm_onlinePeople.text = "在线人数: " + (xm_roomModel?.focus)!
            ///MARK: 计算字体宽度 适配
            let WA = 50.0 + xm_ProfileAuthen.frame.width + 5.0
            let WO = xm_GetTexWidth(textStr:xm_onlinePeople.text!,font: UIFont.init(name: "PingFangSC-Regular", size: 12.0)!,height:12.0)
            if WA > WO {
                bgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self).offset(30.0)
                    make.left.equalTo(self).offset(10.0)
                    make.height.equalTo(40.0)
                    make.right.equalTo(xm_ProfileAuthen.snp.right).offset(80.0)
                }
            }else{
                bgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self).offset(30.0)
                    make.left.equalTo(self).offset(10.0)
                    make.height.equalTo(40.0)
                    make.right.equalTo(xm_onlinePeople.snp.right).offset(80.0)
                }
            }
        }
    }
    ///MARK: 闭包回调
    var xm_headBlock: xm_RoomBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear       ///MARK:设置透明层 black.withAlphaComponent(0.3)
        
        addSubview(bgView)
        addSubview(xm_backButton)
        bgView.addSubview(xm_anchorIcon)
        bgView.addSubview(xm_anchorName)
        bgView.addSubview(xm_onlinePeople)
        bgView.addSubview(xm_foceButtton)
        addSubview(xm_anchorHG)
        addSubview(xm_lookLiveingCollectionView)
        addSubview(xm_ProfileAuthen)
        addSubview(xm_RinkMonthButton)
        addSubview(xm_startImageView)
        addSubview(xm_pxyMoneyButton)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(30.0)
            make.left.equalTo(self).offset(10.0)
            make.height.equalTo(40.0)
            make.right.equalTo(self)
        }
        xm_anchorIcon.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top)
            make.left.equalTo(self).offset(10.0)
            make.width.height.equalTo(40.0)
        }
        xm_anchorHG.snp.makeConstraints { (make) in
            make.top.equalTo(xm_anchorIcon.snp.top).offset(-20.0)
            make.left.equalTo(xm_anchorIcon.snp.left)
            make.right.equalTo(xm_anchorIcon.snp.right)
            make.height.equalTo(20.0)
        }
        xm_anchorName.snp.makeConstraints { (make) in
            make.left.equalTo(xm_anchorIcon.snp.right).offset(10.0)
            make.top.equalTo(xm_anchorIcon.snp.top).offset(3.0)
            make.width.lessThanOrEqualTo(50.0)
        }
        xm_ProfileAuthen.snp.makeConstraints { (make) in
            make.left.equalTo(xm_anchorName.snp.right).offset(5.0)
            make.top.equalTo(xm_anchorName.snp.top).offset(2.0)
        }
        xm_onlinePeople.snp.makeConstraints { (make) in
            make.top.equalTo(xm_anchorName.snp.bottom)
            make.left.equalTo(xm_anchorName.snp.left)
        }
        xm_backButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-10.0)
            make.centerY.equalTo(bgView.snp.centerY)
        })
        ///MARK: 瀑布流
        xm_lookLiveingCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top)
            make.bottom.equalTo(bgView.snp.bottom)
            make.left.equalTo(bgView.snp.right).offset(5.0)
            make.right.equalTo(xm_backButton.snp.left).offset(-5.0)
        }
        ///MARK: 关注
        xm_foceButtton.snp.makeConstraints { (make) in
            make.right.equalTo(bgView.snp.right).offset(-5.0)
            make.top.equalTo(bgView.snp.top).offset(5.0)
            make.bottom.equalTo(bgView.snp.bottom).offset(-5.0)
            make.width.equalTo(60.0)
        }
        
        xm_RinkMonthButton.snp.makeConstraints { (make) in
            make.left.equalTo(xm_anchorIcon.snp.left)
            make.top.equalTo(bgView.snp.bottom).offset(10.0)
        }
        xm_startImageView.snp.makeConstraints { (make) in
            make.left.equalTo(xm_anchorIcon.snp.left)
            make.top.equalTo(xm_RinkMonthButton.snp.bottom).offset(10.0)
        }
        xm_pxyMoneyButton.snp.makeConstraints { (make) in
             make.right.equalTo(self).offset(-10.0)
            make.top.equalTo(bgView.snp.bottom).offset(10.0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension XM_RoomHeadView{
    
    @objc fileprivate func dothings(sender: UIButton) {    ///MARK: 响应事件
        sender.isSelected = !sender.isSelected
        if (self.xm_headBlock != nil) {
            self.xm_headBlock!(_: sender.tag)
        }
    }
}

///MARK: UICollectionViewDelegate代理   ////UICollectionViewDelegateFlowLayout 必须执行此代理方法
extension XM_RoomHeadView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_LookCollectionViewCell.self), for: indexPath) as?XM_LookCollectionViewCell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize.init(width: 30.0, height: 30.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {   // 设置最小列间距，也就是左行与右一行的中间最小间隔
        return  0
    }
}
