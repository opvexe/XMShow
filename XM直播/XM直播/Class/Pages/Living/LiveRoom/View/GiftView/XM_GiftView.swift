//
//  XM_GiftView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/21.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

protocol XM_SendGiftDlegate: NSObjectProtocol{
    func XM_SendGift(xm_gift: XM_GiftModel)
}
class XM_GiftView: UIView {
    ///MARK: 背景视图
    var _window             :UIWindow!
    var _shareViewBackground: UIView!
    
    ///MARK: 礼物瀑布流布局
    fileprivate lazy var xm_GifCollectionView: UICollectionView = {
        let layout = XM_GiftFlowLayout.init()
        layout.cols = 4
        layout.rows = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let xm_GifCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 60.0), collectionViewLayout: layout)
        xm_GifCollectionView.isPagingEnabled = true
        xm_GifCollectionView.showsHorizontalScrollIndicator = false
        xm_GifCollectionView.dataSource = self
        xm_GifCollectionView.delegate = self
        xm_GifCollectionView.register(XM_GiftCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_GiftCollectionViewCell.self))
        xm_GifCollectionView.backgroundColor = UIColor.black
        return xm_GifCollectionView
    }()
    ///MARK: 底部视图
    fileprivate lazy var xm_bottomView: XM_GiftBottomView = {
        let xm_bottomView = XM_GiftBottomView.init()
        xm_bottomView.backgroundColor = UIColor.black
        xm_bottomView.xm_sendGifBlock =  {(_ sender: UIButton) ->Void in
            guard (self.xm_giftDelagate?.XM_SendGift(xm_gift:) != nil) else { return }
            guard  (self.selectedIndexPaths.count > 0)  else { return }
            guard let giftModel = self.giftDate?[(self.selectedIndexPaths[0].row)]  else { return }
            self.xm_giftDelagate?.XM_SendGift(xm_gift:(self.giftDate?[(self.selectedIndexPaths[0].row)])!)
        }
        return xm_bottomView
    }()
    ///MARK: PageControl
    fileprivate lazy var xm_pageControl: UIPageControl = {
        let xm_pageControl = UIPageControl.init(frame: CGRect.zero)
        xm_pageControl.backgroundColor = UIColor.clear
        xm_pageControl.numberOfPages = 1
        xm_pageControl.isEnabled = false
        xm_pageControl.pageIndicatorTintColor = UIColor.white
        xm_pageControl.currentPageIndicatorTintColor = UIColor.orange
        return xm_pageControl
    }()
    ///MARK: 礼物模型
    fileprivate var giftModel : XM_GiftModel = XM_GiftModel()
    fileprivate var giftDate: [XM_GiftModel]?
    
    ///MARK: 选中哪个礼物
    weak var xm_giftDelagate: XM_SendGiftDlegate?
    var selectedIndexPaths = [IndexPath]()
    var xm_selectedIndexPath: IndexPath?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ///MARK:背景视图
        _shareViewBackground = UIView.init(frame: UIScreen.main.bounds)
        _shareViewBackground.backgroundColor = UIColor.clear
        _shareViewBackground.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(XM_GiftView.hidden)))
        ///MARK:礼物视图
        addSubview(xm_GifCollectionView)
        addSubview(xm_bottomView)
        addSubview(xm_pageControl)
        ///加载礼物模型数据
        giftModel.loadData { (result) in
            self.giftDate = result
  
            ///MARK: 设置PageControl总个数       4 --- 2
            self.xm_pageControl.numberOfPages = result.count/8 + 1
            print("xm_pageControl.numberOfPages: \( self.xm_pageControl.numberOfPages)")
            self.xm_GifCollectionView.reloadData()
        }
        
        xm_pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(xm_GifCollectionView.snp.bottom)
            make.height.equalTo(20.0)
        }
        xm_bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(xm_pageControl.snp.bottom)
            make.bottom.equalTo(self)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XM_GiftView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return (self.giftDate?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_GiftCollectionViewCell.self), for: indexPath) as?XM_GiftCollectionViewCell
        cell?.giftModel = self.giftDate?[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize.init(width: kMainBoundsWidth/4, height:80.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let Cell = collectionView.cellForItem(at: indexPath) as? XM_GiftCollectionViewCell
        let Model = self.giftDate?[indexPath.row]
        if self.selectedIndexPaths.count > 0 {
            let prevIp = self.selectedIndexPaths[0]
            if prevIp != indexPath {            ///不相等
                let preCell = collectionView.cellForItem(at: prevIp) as? XM_GiftCollectionViewCell
                ///MARK: 移除上一个选中的礼物
                let preModel = self.giftDate?[prevIp.row]
                preModel?.xm_isSelected = false
                preCell?.giftModel = preModel
                ///MARK: 添加刚刚选中的礼物
                Model?.xm_isSelected = true
                Cell?.giftModel = Model
                self.selectedIndexPaths.removeAll()
                self.selectedIndexPaths.append(indexPath)
            }else{
                Model?.xm_isSelected = true
                Cell?.giftModel = Model
            }
        }else{
            self.selectedIndexPaths.append(indexPath)
            Model?.xm_isSelected = true
            Cell?.giftModel = Model
        }
    }
    ///MARK: 获取滚动当前的CurrentPageControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ///MARK: 方法1
        //        let visiablePath = self.xm_GifCollectionView.indexPathsForVisibleItems.first        ///MARK: 获取可见IndexPath
        //        self.xm_pageControl.currentPage = (visiablePath?.item)! / 8
        ///MARK:方法2
        let pInView = self.convert(self.xm_GifCollectionView.center, to: self.xm_GifCollectionView)  /// 将collectionView在控制器view的中心点转化成collectionView上的坐标
        guard  let indexPathNow = self.xm_GifCollectionView.indexPathForItem(at: pInView) else {return}
        self.xm_pageControl.currentPage = (indexPathNow.item) / 8
    }
}

///MARK: 公开方法
extension XM_GiftView {
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
