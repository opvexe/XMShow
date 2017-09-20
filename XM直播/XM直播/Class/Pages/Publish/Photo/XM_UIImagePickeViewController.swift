//
//  XM_UIImagePickeViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/9/8.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_UIImagePickeViewController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.white), for: UIBarMetrics.default)
        
        let attributes = [
            NSForegroundColorAttributeName : UIColor.black,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}
