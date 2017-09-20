//
//  XMProfileViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

let xm_ProfileHeight: CGFloat = 220.0

class XMProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate var profileArray = NSMutableArray.init(capacity: 0)
    ///懒加载区头
    fileprivate lazy var xm_ProfileView: XMProfileHeadView = {
        let xm_ProfileView = XMProfileHeadView(frame: CGRect.init(x: 0, y: 0, width: kMainBoundsWidth, height: xm_ProfileHeight))
        xm_ProfileView.backgroundColor = UIColor.white
        return xm_ProfileView
    }()
    ///懒加载UITableview
    fileprivate lazy var profileTableView: UITableView = {[unowned self] in
        
        let profileTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kMainBoundsWidth, height: kMainBoundsHeight - 49.0), style: UITableViewStyle.plain)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.showsVerticalScrollIndicator = false
        profileTableView.rowHeight  = 44.0
        profileTableView.backgroundColor = UIColor.themTableViewBackgroundColor(alpha: 0.5)
        profileTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kMainBoundsWidth, height: xm_ProfileHeight))
        profileTableView.tableFooterView = UIView.init()
        profileTableView.addSubview(self.xm_ProfileView)
        return profileTableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false  ///防止状态栏偏移
        getDateSouce()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension XMProfileViewController{
    
    fileprivate func getDateSouce() {
        let dateSouce = [
            [["title":"我的预约","imageProfile":"mine_follow"],
             ["title":"我的预告","imageProfile":"mine_money"],
             ["title":"我的日志","imageProfile":"mine_follow"],
             ["title":"我的收藏","imageProfile":"mine_follow"]],

            [["title":"编辑资料","imageProfile":"mine_edit","ClsName":"XMEditProfileViewController"],
             ["title":"设置","imageProfile":"mine_set"]],
            ]
        profileArray = XMProfileModel.mj_objectArray(withKeyValuesArray: dateSouce)
        view.addSubview(profileTableView)
        profileTableView.reloadData()
    }
}

extension XMProfileViewController{          ///UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (profileArray[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(XMProfileTableViewCell.self)) as? XMProfileTableViewCell
        if cell == nil {
            cell = XMProfileTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: NSStringFromClass(XMProfileTableViewCell.self))
        }
        
        let arrM = profileArray[indexPath.section] as? [XMProfileModel]
        cell?.ModelSetting  = arrM?[indexPath.row]
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrM = profileArray[indexPath.section] as? [XMProfileModel]
        let Model = arrM?[indexPath.row]
        if ((Model?.ClsName) != nil) {
            let vc = xm_ClassFromString(className: (Model?.ClsName)!)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        print("点击:\(indexPath.section,indexPath.row)")
    }
}

extension XMProfileViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("\(offsetY)")
        if offsetY <= 0 {
            xm_ProfileView.frame = CGRect(x: offsetY * 0.5, y: offsetY, width: kMainBoundsWidth - offsetY, height: xm_ProfileHeight - offsetY)
        }
    }
}

