//
//  UIImageView+Category.swift
//  XM直播
//
//  Created by GDBank on 2017/8/29.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import FLAnimatedImage

extension FLAnimatedImageView {
    ///MARK: 下载Gif图片
   public func setImage(with url: URL?, placeholderImage: UIImage?) {
        sd_internalSetImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions(rawValue: 0), operationKey: nil, setImageBlock: { [weak self] (image, imageData) in
            guard let strongSelf = self else { return }
            
            let imageFormat = NSData.sd_imageFormat(forImageData: imageData)
            if imageFormat == .GIF {
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.animatedImage = animatedImage
                        strongSelf.image = nil
                    }
                }
            } else {
                strongSelf.image = image
                strongSelf.animatedImage = nil
            }
            }, progress: nil, completed: nil)
    }
}

extension UIImage {
    
   public func fixOrientationWithImage(image:UIImage) -> UIImage {            ///MARK: 纠正图片方向 例如 拍照左侧对应右侧
        
        let reulstImage = image;
        if (reulstImage.imageOrientation == UIImageOrientation.up) {return reulstImage;}
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity;
        
        switch (reulstImage.imageOrientation)
        {
        case .down, .downMirrored:
            
            transform = transform.translatedBy(x: reulstImage.size.width, y: reulstImage.size.height)
            transform = transform.rotated(by: CGFloat.pi);
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: reulstImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2);
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: reulstImage.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2);
        case .up, .upMirrored:()
            
        }
        
        switch (reulstImage.imageOrientation)
        {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x:reulstImage.size.width, y:0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x:reulstImage.size.height, y:0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .up,.down,.left,.right:()
            
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(reulstImage.size.width), height: Int(reulstImage.size.height),
                            bitsPerComponent: reulstImage.cgImage!.bitsPerComponent, bytesPerRow: 0,
                            space: reulstImage.cgImage!.colorSpace!,
                            bitmapInfo: reulstImage.cgImage!.bitmapInfo.rawValue);
        
        ctx!.concatenate(transform);
        
        switch (reulstImage.imageOrientation)
        {
        case .left,.leftMirrored,.right,.rightMirrored:
            ctx!.draw(reulstImage.cgImage!, in: CGRect(x:0,y:0,width:reulstImage.size.height,height:reulstImage.size.width))
        default:
            ctx!.draw(reulstImage.cgImage!, in: CGRect(x:0,y:0,width:reulstImage.size.width,height:reulstImage.size.height))
        }
        let cgimg = ctx!.makeImage();
        let img = UIImage(cgImage: cgimg!)
        return img;
        
    }
}
