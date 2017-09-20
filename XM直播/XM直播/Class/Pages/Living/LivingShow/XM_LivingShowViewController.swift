//
//  XM_LivingShowViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/14.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import MJRefresh
import MJExtension

class XM_LivingShowViewController: UIViewController {
    
    var ShowStyle: XMLiveStyleModel?
    
    fileprivate lazy var livingShowCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let livingShowCollectionView = UICollectionView.init(frame:CGRect(x: 0, y: 0, width: kMainBoundsWidth, height: kMainBoundsHeight - 49 - 64), collectionViewLayout: layout)
        livingShowCollectionView.showsHorizontalScrollIndicator = false
        livingShowCollectionView.showsVerticalScrollIndicator  = false
        livingShowCollectionView.dataSource = self
        livingShowCollectionView.delegate = self
        livingShowCollectionView.register(XM_ShowCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_ShowCollectionViewCell.self))
        livingShowCollectionView.register(XM_HotCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_HotCollectionViewCell.self))
        livingShowCollectionView.register(XM_ChoiceCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(XM_ChoiceCollectionViewCell.self))
        livingShowCollectionView.register(XM_ShowCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(XM_ShowCollectionReusableView.self))
        livingShowCollectionView.backgroundColor = UIColor.white
        return livingShowCollectionView
    }()
    
    fileprivate var showArrM = [XM_LiveShowModel]()
    fileprivate var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(livingShowCollectionView)
        
        livingShowCollectionView.mj_header  = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(XM_LivingShowViewController.liveRequstNetwork(index:)))
        livingShowCollectionView.mj_header.beginRefreshing()
        livingShowCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(XM_LivingShowViewController.liveRequstNetworkMore(index:)))
    }
}

extension XM_LivingShowViewController{
    
    /// Mark: 下拉刷新
    @objc fileprivate  func liveRequstNetwork(index: Int)  {
        XM_Network.request(method: .get, url: LiveHomeUrl, parameters:["type":self.ShowStyle?.type ?? AnyObject.self, "index" : self.index, "size":arc4random_uniform(6) + 42]) { (json, error) in
            print("request:\(json)")
            self.showArrM.removeAll()
            guard let resultDict = json as? [String : Any],
                let messageDict = resultDict["message"] as? [String : Any],
                let anchorsArray = messageDict["anchors"] as? [[String : Any]]
                else {
                    return self.livingShowCollectionView.mj_header.endRefreshing()
            }
            self.showArrM = XM_LiveShowModel.mj_objectArray(withKeyValuesArray: anchorsArray) as! [XM_LiveShowModel]
            self.livingShowCollectionView.mj_header.endRefreshing()
            self.livingShowCollectionView.reloadData()
        }
    }
    
    ///Mark: 上拉加载
    @objc fileprivate func liveRequstNetworkMore(index: Int) {
        self.index += 1
        var templeArrM = [XM_LiveShowModel]()
        XM_Network.request(method: .get, url: LiveHomeUrl, parameters:["type" : self.ShowStyle?.type ?? AnyObject.self, "index" : self.index, "size":arc4random_uniform(6) + 42]) { (json, error) in
            print("request:\(json)")
            guard let resultDict = json as? [String : Any],
                let messageDict = resultDict["message"] as? [String : Any],
                let anchorsArray = messageDict["anchors"] as? [[String : Any]]
                else {
                    return self.livingShowCollectionView.mj_header.endRefreshing()
            }
            templeArrM .removeAll()
            templeArrM = XM_LiveShowModel.mj_objectArray(withKeyValuesArray: anchorsArray) as! [XM_LiveShowModel]
            self.showArrM += templeArrM         ///将Templ数组添加到ShowArrM
            self.livingShowCollectionView.mj_footer.endRefreshing()
            self.livingShowCollectionView.reloadData()
        }
        
    }
}

extension XM_LivingShowViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return self.showArrM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell: XM_BaseCollectionViewCell?
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_ShowCollectionViewCell.self), for: indexPath) as?XM_ShowCollectionViewCell
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_HotCollectionViewCell.self), for: indexPath) as?XM_HotCollectionViewCell
            self.livingShowCollectionView.backgroundColor = UIColor.themTableViewBackgroundColor(alpha: 0.5)
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_ChoiceCollectionViewCell.self), for: indexPath) as?XM_ChoiceCollectionViewCell
            self.livingShowCollectionView.backgroundColor = UIColor.themTableViewBackgroundColor(alpha: 0.5)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(XM_ShowCollectionViewCell.self), for: indexPath) as?XM_ShowCollectionViewCell
        }
        
        cell?.showModelSetting = self.showArrM[indexPath.row]
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 0:
            return CGSize(width: kMainBoundsWidth, height: 288)
        case 1:
            return CGSize.init()
        case 2:
            return CGSize.init()
        default:
            return CGSize.init()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        var reusableview: UICollectionReusableView?
        if kind  == UICollectionElementKindSectionHeader {
            let  reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(XM_ShowCollectionReusableView.self), for: indexPath) as? XM_ShowCollectionReusableView
            reusable?.xm_delegate = self
            reusableview = reusable
        }
        return reusableview!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)       ///距离两边距left right  top 距离区头 botton 距离区尾
        
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 1:
            return UIEdgeInsetsMake(10, 10, 20, 10)
        case 2:
            return UIEdgeInsetsMake(10.0, 3.0, 10.0, 3.0)
        default:
            return UIEdgeInsetsMake(20, 10, 20, 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 0:
            return CGSize.init(width: (kMainBoundsWidth - 30)/2, height: 150)
        case 1:
            return CGSize.init(width: kMainBoundsWidth, height: 288)
        case 2:
            return CGSize.init(width: (kMainBoundsWidth - 10)/2, height: 220)
        default:
            return CGSize.init(width: (kMainBoundsWidth - 30)/2, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {   // 设置最小列间距，也就是左行与右一行的中间最小间隔
        
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 2:
            return 3.0
        default:
            return 10.0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // 设置最小行间距，也就是前一行与后一行的中间最小间隔
        let typeC: Int = (self.ShowStyle?.type)!
        switch typeC {
        case 2:
            return 5.0
        default:
            return 10.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        requstPullStreaming(model: self.showArrM[indexPath.row]) { (result) in
            let liveRoomController = XM_LiveRoomViewController()
            liveRoomController.xm_liveRoomModel = self.showArrM[indexPath.row]
            liveRoomController.liveURLString = result
            liveRoomController.modalTransitionStyle = .crossDissolve
            self.present(liveRoomController, animated: true) {
                print("模态进入直播间")
            }
        }
    }
}
///MARK: 获取拉流地址
extension XM_LivingShowViewController {         ///MARK: 逃逸闭包与非逃逸闭包区别 （逃逸闭包 --- 函数块执行完后执行回调） 非逃逸闭包
    fileprivate func  requstPullStreaming(model: XM_LiveShowModel,completion: @escaping (_ result: String) -> ()) ->(){
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056", "signature" : "f69f4d7d2feb3840f9294179cbcb913f", "roomId" : model.roomid ?? String(), "userId" : model.uid ?? String()]
        XM_Network.request(method: .get, url: PullStreamingUrl, parameters: parameters as NSDictionary) { (jason, error) in
            print("拉流地址:\(jason)")
            guard let resultDict = jason as? [String : Any] else {return}
            guard let infoDict = resultDict["message"] as? [String : Any] else{ return}
            guard let rURL = infoDict["rUrl"] as? String else{ return}
            XM_Network.request(method: .get, url: rURL, parameters: nil, finishedCallback: { (jason, error) in
                print("拉流房间号地址:\(jason)")
                guard let resultDict = jason as? [String : Any] else { return }
                guard let liveURLString =  resultDict["url"] as? String else { return }
                completion(liveURLString)
            })
        }
    }
}

///MARK: 执行点击游戏代理行为
extension XM_LivingShowViewController: xm_ShowGameDelegate{
    func xm_showGameClickAtIndex(index: Int) {
        switch index - 1000 {
        case 0:
            let lplController = XM_LplRoomViewController()          ///MARK: 英雄联盟
            navigationController?.pushViewController(lplController, animated: true)
        case 1:
            let lplController = XM_LplRoomViewController()           ///MARK: 王者荣耀
            navigationController?.pushViewController(lplController, animated: true)
        case 2:
            let lplController = XM_LplRoomViewController()           ///MARK: LPL
            navigationController?.pushViewController(lplController, animated: true)
        case 3:
            let lplController = XM_LplRoomViewController()           ///MARK: 户外直播
            navigationController?.pushViewController(lplController, animated: true)
        default:
            break
        }
    }
}

