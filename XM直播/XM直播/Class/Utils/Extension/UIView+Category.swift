//
//  UIView+Category.swift
//  XM直播
//
//  Created by GDBank on 2017/8/24.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import Foundation
import UIKit

let LINE_WIDTH = CGFloat(1.0)
let SINGLE_LINE_ADJUST_OFFSET = floor(((LINE_WIDTH / UIScreen.main.scale) / 2)*100) / 100

extension UIView{
    
    
    var  HY_x : CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame : CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    
    var  HY_y : CGFloat {
        get{
            return self.frame.origin.y
        }
        
        set{
            var frame : CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    
    var  HY_width : CGFloat {
        get{
            return self.frame.width
        }
        
        set{
            var frame :CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var  HY_height : CGFloat {
        get{
            return self.frame.height
        }
        
        set{
            var frame :CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    
    
    var HY_centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            var center :CGPoint = self.center
            center.x = newValue
            self.center = center
            
        }
    }
    
    
    
    var HY_centerY : CGFloat{
        get{
            return self.center.y
        }
        
        set{
            var center :CGPoint = self.center
            center.y = newValue
            self.center = center
            
        }
    }
    
}

extension UIView {
    ///MARK: 绘制Top线型
    open func addTopBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        var pixelAdjustOffset = 0.0
        let scale = UIScreen.main.scale
        if Int(borderWidth*(scale + 1))%2 == 0{
            pixelAdjustOffset = Double(SINGLE_LINE_ADJUST_OFFSET)
        }
        let border = CAShapeLayer.init()
        border.backgroundColor = color.cgColor
        border.frame = CGRect.init(x: CGFloat(-pixelAdjustOffset), y: 0, width:self.frame.size.width , height: borderWidth)
        self.layer.addSublayer(border)
    }
    ///MARK: 绘制Bottom线型
    open func addBottomBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        let border = CAShapeLayer.init()
        border.backgroundColor = color.cgColor
        border.frame = CGRect.init(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        border.name = "border"
        self.layer.addSublayer(border)
    }
    ///MARK: 绘制Left线型
    open func addLeftBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        let border = CAShapeLayer.init()
        border.backgroundColor = color.cgColor
        border.frame = CGRect.init(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    ///MARK: 绘制Right线型
    open func addRightBorderWithColor(color: UIColor, borderWidth: CGFloat) {
        let border = CAShapeLayer.init()
        border.backgroundColor = color.cgColor
        border.frame = CGRect.init(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    ///MARK: 开启粒子效果动画
    open func startEmittering(_ point : CGPoint)  {
        // 1. 创建发射器
        let emitter = CAEmitterLayer()
        
        // 2. 设置发射器的位置
        emitter.emitterPosition = point
        
        // 3. 开启三维效果
        emitter.preservesDepth = true
        
        // 4. 创建粒子,并且设置粒子的相关属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1 创建粒子cell
            let cell = CAEmitterCell()
            
            // 4.2 设置例子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            // 4.3 设置粒子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-M_PI_2)
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            
            // 4.5 设置粒子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            // 4.6 设置粒子的旋转方向
            cell.spin = CGFloat(M_PI_2)
            cell.spinRange = CGFloat(M_PI_2 / 2)
            
            // 4.7 设置粒子每秒弹出的个数
            cell.birthRate = 4
            
            // 4.8 设置例子的展示图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            // 4.9 添加到数组中
            cells.append(cell)
            
        }
        
        // 5 将粒子设置到发射器中
        emitter.emitterCells = cells
        
        // 6. 将发射器的layer添加到父layer中
        layer.addSublayer(emitter)
        
    }
    ///MARK: 关闭粒子效果动画
    open func stopEmitter(){
        layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}

extension UIView {
    ///MARK: 缩放动画
    open func scalingWithTime(time: TimeInterval,scal: CGFloat){
        UIView.animate(withDuration: time) {
            self.transform = CGAffineTransform.init(scaleX: scal, y: scal)
        }
    }
    ///MARK: 旋转动画
    open func RevolvingWithTime(time: TimeInterval,delta: CGFloat){
        UIView.animate(withDuration: time) {
            self.transform = CGAffineTransform.init(rotationAngle: delta)
        }
    }
}
