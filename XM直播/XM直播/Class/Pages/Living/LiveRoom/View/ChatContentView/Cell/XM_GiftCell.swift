//
//  XM_GiftCell.swift
//  XM直播
//
//  Created by GDBank on 2017/8/29.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit

class XM_GiftCell: UITableViewCell {
    
    fileprivate lazy var xm_sendGiftName: UILabel = {
        let xm_sendGiftName = UILabel.init()
        UILabel.setBoldSystemSingleLabel(styleLabel: xm_sendGiftName, textColor: UIColor.cyan, fontSize: 14.0)
        return xm_sendGiftName
    }()
    
    fileprivate lazy var xm_giftImageView: UIImageView = {
        let xm_giftImageView = UIImageView.init()
        xm_giftImageView.contentMode = .scaleAspectFill
        return xm_giftImageView
    }()
    
    var xm_giftModel: GiftModel?{
        didSet{
            xm_sendGiftName.text = (xm_giftModel?.name)! + "  赠送了  " + String.init(format: "%ld个 ", (xm_giftModel?.giftCount)!) +  (xm_giftModel?.giftName)!
            xm_giftImageView.sd_setImage(with: URL.init(string: (xm_giftModel?.giftImage)!), placeholderImage: UIImage.init(named: "icon-gift"))
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        
        contentView.addSubview(xm_sendGiftName)
        contentView.addSubview(xm_giftImageView)
        
        xm_sendGiftName.snp.makeConstraints { (make) in
            make.left.equalTo(10.0)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        xm_giftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(xm_sendGiftName.snp.right).offset(10.0)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(30.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
