//
//  XMTabBarViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XMTabBarViewController: UITabBarController {
    
    ///MARK: 弹出视图
    
    fileprivate lazy var shadeView: XM_PublishView = {
        let shadeView = XM_PublishView.init(frame:CGRect.zero, imageArr: ["x6_photo_h","tab_icon_vedio","tab_icon_live"], titleArr: ["相册","录视频","直播"])
        shadeView.xm_PublishBlock = {(_ tag: NSInteger, _ sender: UIButton) ->Void in
            switch tag - 100 {
            case 0:
                let Photo = XM_PhotoViewController()
                Photo.modalTransitionStyle = .crossDissolve
                self.present(Photo, animated: true) {}
            case 1:
                let RecordVideo = XM_RecordVideoViewController()
                RecordVideo.modalTransitionStyle = .crossDissolve
                self.present(RecordVideo, animated: true) {}
            case 2:
                print("直播")
            default:
                break
            }
        }
        return shadeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        ///去除TabBar顶部阴影
        self.tabBar.backgroundImage = UIImage.init()
        self.tabBar.shadowImage = UIImage.init()
        self.delegate = self
        
        XM_PlacemarkManger.sharedInstance.getPlacemark({ (placemarkModel) in
            print("当前城市区: = \(String(describing: placemarkModel?.county))")
        }) { (error) in
        }
        ///MARK: 设置子控制器
        setRootControllers()
        ///MARK: 发布
        setUpPublishBtn()
        
    }
}

///MARK: 添加发布按钮
extension XMTabBarViewController{
    fileprivate func setUpPublishBtn() {
        let publishButton = XM_TabbarButton.init(type: UIButtonType.custom)
        publishButton.imageView?.contentMode = .scaleAspectFit
        publishButton.setImage(UIImage.init(named: "post_normal"), for: UIControlState.normal)
        publishButton.setTitle("发布", for: UIControlState.normal)
        publishButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        publishButton.setTitleColor(UIColor.yellow, for: UIControlState.selected)
        publishButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        publishButton.titleLabel?.textAlignment = .center
        publishButton.addTarget(self, action: #selector(XMTabBarViewController.publishVideo), for: .touchUpInside)
        publishButton.frame = CGRect.init(x: (self.tabBar.bounds.size.width - 55.0)/2, y: self.tabBar.bounds.size.height - 80.0, width: 55.0, height: 80.0)
        self.tabBar.addSubview(publishButton)
        self.tabBar.bringSubview(toFront: publishButton)
    }
    
    ////MARK: 点击发布按钮
    @objc fileprivate  func publishVideo(sender: UIButton) {
             shadeView.show()
    }
}

extension XMTabBarViewController{
    
    func setRootControllers() {
        
        let Array = [
            ["className":"XMLivingViewController","title":"首页","imageIcon":"home"],
            ["className":"XM_VideoViewController","title":"视频","imageIcon":"message_center"],
            ["className":"XM_PublishViewController","title":"","imageIcon":""],
            ["className":"XMDiscoverViewController","title":"关注","imageIcon":"discover"],
            ["className":"XMProfileViewController","title":"我的","imageIcon":"profile"],
            ]
        
        var ArrM = [UIViewController]()
        for dic in Array {
            ArrM.append(setNavConrollers(param: dic))
        }
        viewControllers = ArrM
    }
}

extension XMTabBarViewController{
    
    func setNavConrollers(param:[String :Any]) -> UIViewController {
        
        guard let clsName = param["className"] as? String,
            let title   = param["title"] as? String,
            let imageIcon = param["imageIcon"] as? String,
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
            else {
                return UIViewController()
        }
        
        let vc = cls.init()
        guard vc is  XM_PublishViewController else {
            vc.title = title
            vc.tabBarItem.image = UIImage(named: "tabbar_" + imageIcon)
            vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageIcon + "_selected")?.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.brown], for: .selected)
            vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
            
            let nav = XMNavigationViewController.init(rootViewController: vc)
            return nav
        }
        
        vc.tabBarItem.isEnabled = false
        vc.tabBarItem.title = nil
        return vc
    }
}
///MARK: UITabBarControllerDelegate 代理行为
extension XMTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
    }
}
