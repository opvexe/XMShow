//
//  Bundle+Category.swift
//  XM直播
//
//  Created by GDBank on 2017/8/10.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import Foundation
import UIKit


extension Bundle{
    var nameSpace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

/**
 *  {convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
    便利构造函数通常用在对系统的类进行构造函数的扩充时使用。
    便利构造函数的特点：
    1、便利构造函数通常都是写在extension里面
    2、便利函数init前面需要加载convenience
    3、在便利构造函数中需要明确的调用self.init()
 *  }
 *  枚举和结构体的静态方法使用的关键字是static
 *  类的静态方法使用的关键字是class。
 **/
extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0);
    }
    
    //MARK: 随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)));
    }
    //MARK: - 十六进制返回颜色
    class  func colorWithHex(_ hexValue:u_long) ->  UIColor{
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
        return ResultColor
    }
    //MARK: - 十六进制与透明度返回颜色
    class  func colorWithHexAlpha(_ hexValue:u_long,alpha:CGFloat) -> UIColor {
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: Float(alpha))
        return ResultColor
    }
    ///MARK: 将颜色转换成图片
    class func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //MARK: - RGB与透明度返回颜色
    class func colorWithRGBAlpha(_ red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        let resultColor = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        return resultColor
    }
    
    //MARK: - 白色字体颜色
    class func themeWhitColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0xFFFFFF)
        return themecharactercolor
    }
    
    //MARK: - 黑色字体颜色
    class func themeBlackColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x333333)
        return themecharactercolor
    }
    
    //MARK: - 灰色字体颜色
    class func themeGrayColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x666666)
        return themecharactercolor
    }
    
    //MARK: - 浅灰色字体颜色
    static func themeLightGrayColors() -> UIColor {
        let themecharactercolor = self.colorWithHex(0x999999)
        return themecharactercolor
    }
    ///MARK: - TableView背景颜色
   static func themTableViewBackgroundColor(alpha:  Float) -> UIColor{
        let themecharactercolor = UIColor.init(colorLiteralRed: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: alpha)
        return themecharactercolor
    }
}


