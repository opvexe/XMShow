//
//  XMNavigationViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XMNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = UIColor.clear
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage.init()
        
        let attributes = [
            NSForegroundColorAttributeName : UIColor.brown,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0  {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        }
        super.pushViewController(viewController, animated: true)
    }
}

extension XMNavigationViewController{
    
   fileprivate func setBackBarButtonItem() -> UIBarButtonItem {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "icon_back_me"), for: .normal)
        backButton.setImage(UIImage(named: "icon_back_me"), for: .highlighted)
        backButton.sizeToFit()
        backButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        backButton.addTarget(self, action: #selector(XMNavigationViewController.backClick), for: .touchUpInside)
        return UIBarButtonItem.init(customView: backButton)
    }
    
  @objc fileprivate  func backClick() {
        self.popViewController(animated: true)
    }
}
