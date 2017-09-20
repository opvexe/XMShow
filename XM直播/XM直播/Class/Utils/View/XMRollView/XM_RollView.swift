//
//  XM_RollView.swift
//  XM直播
//
//  Created by GDBank on 2017/8/16.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SnapKit

var kViewHeight: CGFloat = 220.0
class XM_RollView: UIView {

    fileprivate lazy var carouselCollectionView : UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.itemSize = CGSize(width: kMainBoundsWidth, height: kViewHeight)
        layout.minimumLineSpacing = 0
        let carouselCollectionView:UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.backgroundColor = UIColor.white
        carouselCollectionView.register(XM_RollCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_RollCollectionViewCell.self))
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        return carouselCollectionView
        }()
    
    fileprivate lazy var pageControl : UIPageControl = {
        let pageControl:UIPageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 1
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.brown
        return pageControl
    }()
    
    var timer:Timer?
    
    var carouselModelArr : [XM_RollModel]? {
        didSet {
            self.carouselCollectionView.reloadData()
            pageControl.numberOfPages = carouselModelArr?.count ?? 0
            
            let index = (carouselModelArr?.count ?? 0)*10
            self.carouselCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
            
            removeTimer()
            addTimer()
        }
    }
    
    init(Y: CGFloat,H:CGFloat) {
        kViewHeight = H
        super.init(frame: CGRect(x: 0, y: Y, width: kMainBoundsWidth, height: kViewHeight))
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- setup UI
extension XM_RollView {
    func setupUI() {
        self.addSubview(carouselCollectionView)
        self.addSubview(pageControl)
      
        ///添加PageControl约束
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(10.0)
            make.bottom.equalTo(self).offset(-10.0)
        }
        
    }
}

//MARK:- collectionViewDataSource
extension XM_RollView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000*(carouselModelArr?.count ?? 0);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionItem = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_RollCollectionViewCell.self), for: indexPath) as! XM_RollCollectionViewCell
        let index = indexPath.item % carouselModelArr!.count
        collectionItem.carouselModel = carouselModelArr![index]
        return collectionItem
    }
    
}

//MARK:- collectionViewDelegate
extension XM_RollView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + kMainBoundsWidth / 2
        pageControl.currentPage = Int(offset / kMainBoundsWidth) % (carouselModelArr?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}

//MARK:- 添加计时器
extension XM_RollView {
    func addTimer() {
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollToNextPage() {
        let offsetX = carouselCollectionView.contentOffset.x + kMainBoundsWidth//当前偏移量加上一页的宽度
        carouselCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
