//
//  AppDelegate.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = XMTabBarViewController()
        
        ///MARK: 全局打开状态栏  -- -- > View controller-based status bar appearance == yes   Status bar is initially hidden == yes --->Hide Status bar 勾选
        UIApplication.shared.isStatusBarHidden = false
        
        TYFPSLabel.showInStutasBar()            
        
        window?.makeKeyAndVisible()
        return true
    }
}

