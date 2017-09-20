//
//  XMLivingViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import MJExtension

class XMLivingViewController: UIViewController {
    fileprivate var titles : [String]!
    fileprivate var style : XJTitleStyle!
    fileprivate var childVcs = [UIViewController]()
    fileprivate var titleView : XJTitleView!
    fileprivate var contentView : XJContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
             navigationController?.navigationBar.isHidden = true///隐藏标题
        let typeList = getMoreTypeList()
        let titles = typeList.map({$0.title})
        
        ///设置对应VC模型
        for type in typeList {
            let vc = XM_LivingShowViewController()
            vc.ShowStyle = type
            childVcs.append(vc)
        }
        ///设置样式
        let style = XJTitleStyle()
        style.isShowBottomLine = true
        style.selectedColor = UIColor.brown
        ///设置标题
        let titleH : CGFloat = style.titleHeight
        let titleFrame = CGRect(x: 0, y: 20, width: kMainBoundsWidth, height: titleH)
        titleView = XJTitleView(frame: titleFrame, titles: titles as! [String], style : style)
        titleView.delegate = self
        navigationController?.view.addSubview(titleView)
        ///设置滚动区
        let contentFrame = CGRect(x: 0, y: titleH + 20, width: kMainBoundsWidth, height: kMainBoundsHeight - titleH - 20)
        contentView = XJContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        view.addSubview(contentView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        titleView.isHidden = true
    }
}

extension XMLivingViewController{
    fileprivate  func getMoreTypeList() ->[XMLiveStyleModel] {
        let arrM = [
            ["title":"星秀","type":0],
            ["title":"热门","type":1],
            ["title":"星颜","type":2],
            ["title":"美食","type":3],
            ["title":"户外","type":4],
            ["title":"二次元","type":5],
            ["title":"畅聊","type":6],
            ["title":"音乐","type":7],
            ["title":"萌宠","type":8],
            ]
        let ArryType = XMLiveStyleModel.mj_objectArray(withKeyValuesArray: arrM) as! [XMLiveStyleModel]
        return ArryType
    }
}

extension XMLivingViewController : XJContentViewDelegate {
    func contentView(_ contentView: XJContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    func contentViewEndScroll(_ contentView: XJContentView) {
        titleView.contentViewDidEndScroll()
    }
}

extension XMLivingViewController : XJTitleViewDelegate {
    func titleView(_ titleView: XJTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}


