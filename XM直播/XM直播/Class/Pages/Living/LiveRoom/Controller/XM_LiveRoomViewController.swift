//
//  XM_LiveRoomViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/8/16.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import IJKMediaFramework
import FLAnimatedImage

private let warnTitle = "系统消息: 如直播间出现色情低俗,违法违规,聚众闹事,涉政及抽烟喝酒等内容,请及时举报,共建健康社区, ★ 网警24小时巡查★"
class XM_LiveRoomViewController: UIViewController {
    
    var xm_liveRoomModel: XM_LiveShowModel?
    var liveURLString: String?
    ///MARK: 头部视图
    fileprivate lazy var xm_HeadView: XM_RoomHeadView = {
        let xm_HeadView = XM_RoomHeadView.init(frame: CGRect.init(x: 0, y: 0, width: kMainBoundsWidth, height: 140.0))
        xm_HeadView.xm_roomModel = self.xm_liveRoomModel
        xm_HeadView.xm_headBlock = {(_ tag: NSInteger) ->Void in            ///MARK:闭包回调
            switch tag - 1000 {
            case 1:
                self.dismiss(animated: true, completion: nil)
                self.ijkPlayer.stop()
            case 2:
                print("关注")
            case 3:
                print("排行榜")
            case 4:
                print("竞猜")
            default:
                break
            }
        }
        return xm_HeadView
    }()
    ///MARK: 底部视图
    fileprivate lazy var xm_footView: XM_RoomFootView = {
        let xm_footView = XM_RoomFootView.init(frame: CGRect.init(x: 0, y: kMainBoundsHeight - 40.0, width: kMainBoundsWidth, height: 40.0))
        xm_footView.xm_shardGifBlock = {(_ tag: NSInteger,_ sender: UIButton) ->Void in
            switch tag - 100 {
            case 0:
                print("聊天")
                self.chatView?.xm_chatTextView.becomeFirstResponder()
            case 1:
                print("礼物")
                self.giftView?.show()
            case 2:
                print("分享")
                self.shareView?.show()
            case 3:
                print("粒子动画")
                sender.isSelected = !sender.isSelected
                if sender.isSelected{       ///MARK: 开启粒子动画
                    self.ijkPlayer.view.startEmittering(CGPoint(x: kMainBoundsWidth*3/4 + kMainBoundsWidth/8, y: kMainBoundsHeight - 40))
                }else{                     ///MARK: 关闭粒子动画
                    self.ijkPlayer.view.stopEmitter()
                }
            default:
                break
            }
        }
        return xm_footView
    }()
    ///MARK: 聊天记录 "系统消息: 如直播间出现色情低俗,违法违规,聚众闹事,涉政及抽烟喝酒等内容,请及时举报,共建健康社区, ★网警24小时巡查★"
    fileprivate lazy var xm_warnHeadView: XM_ChatWarnHeadView = {
        let xm_warnHeadView = XM_ChatWarnHeadView.init(frame: CGRect.zero, warnTitle: warnTitle)
        xm_warnHeadView.backgroundColor = UIColor.clear
        return xm_warnHeadView
    }()
    fileprivate lazy var xm_chatTableView: UITableView = {
        let xm_chatTableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        xm_chatTableView.delegate = self
        xm_chatTableView.dataSource = self
        xm_chatTableView.showsVerticalScrollIndicator = false
        xm_chatTableView.rowHeight  = 30.0
        xm_chatTableView.backgroundColor = UIColor.clear
        xm_chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        xm_chatTableView.tableFooterView = UIView.init()
        xm_chatTableView.tableHeaderView = self.xm_warnHeadView
        return xm_chatTableView
    }()
    ///MARK: 背景高斯模糊图片
    fileprivate lazy var xm_bgImageView: UIImageView = {
        let xm_bgImageView = UIImageView.init(frame: UIScreen.main.bounds)
        let placeImageColor = UIColor.creatImageWithColor(color: UIColor.yellow)
        xm_bgImageView.sd_setImage(with: URL.init(string: (self.xm_liveRoomModel?.pic51)!), placeholderImage: placeImageColor)
        xm_bgImageView.isUserInteractionEnabled = true
        return xm_bgImageView
    }()
    ///MARK: 直播间底部视图
    var chatView: XM_ChatView?
    var giftView: XM_GiftView?
    var shareView: XM_ShareView?
    ///MARK: 直播ijkPlayer
    fileprivate lazy var ijkPlayer: IJKFFMoviePlayerController = {
        let options = IJKFFOptions.byDefault() /// 1代表是硬解码 0 代表是软解码
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        let ijkPlayer = IJKFFMoviePlayerController(contentURLString: self.liveURLString, with: options)
        ijkPlayer?.view.frame = self.view.bounds
        ijkPlayer?.scalingMode = .aspectFill
        return ijkPlayer!
    }()
    ///MARK: 聊天数组
    var dataSource = [GiftModel]()
    ///MARK: 大动画视图
    fileprivate var zipGiftImageView: FLAnimatedImageView = {
        let zipGiftImageView = FLAnimatedImageView.init()
        zipGiftImageView.backgroundColor = UIColor.clear
        return zipGiftImageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        ///MARK: 状态栏颜色
        UIApplication.shared.statusBarStyle = .lightContent
        createBlurBackground(image: xm_bgImageView.image!, view: self.view, blurRadius: 8.0)
        ///MARK: 开始直播
        view.addSubview((ijkPlayer.view)!)
        ijkPlayer.prepareToPlay()
        ijkPlayer.play()
        ///MARK: 头部底部视图
        ijkPlayer.view.addSubview(xm_HeadView)
        ijkPlayer.view.addSubview(xm_footView)
        ijkPlayer.view.addSubview(xm_chatTableView)
        ijkPlayer.view.addSubview(zipGiftImageView)
        ///MARK: 注册键盘通知 &&UITextViewTextDidChange
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        ///MARK: 添加底部视图弹框
        setSubFootView()
        
        ///MARK:布局聊天视图
        xm_chatTableView.snp.makeConstraints { (make) in
            make.left.equalTo(ijkPlayer.view.snp.left)
            make.bottom.equalTo(xm_footView.snp.top).offset(-10.0)
            make.width.equalTo(ijkPlayer.view.snp.width).multipliedBy(0.75)
            make.height.equalTo(180.0)
        }
        ///MARK: 动画礼物
        zipGiftImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.height.equalTo(160.0)
        }
    }
    ///MARK: 关闭定时器
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///关闭粒子效果动画
        self.ijkPlayer.view.stopEmitter()
        ///MARK: 恢复状态栏的颜色
        UIApplication.shared.statusBarStyle = .default
    }
    ///dealloc ，移除所有通知
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

///MARK: 添加底部视图
extension XM_LiveRoomViewController{
    
    fileprivate func setSubFootView(){
        ///MARK: 聊天视图
        chatView = XM_ChatView.init(frame: CGRect.init(x: 0, y: kMainBoundsHeight, width: kMainBoundsWidth, height: 44.0))
        view.addSubview(chatView!)
        ///MARK: 礼物视图
        giftView = XM_GiftView.init(frame: CGRect.init(x: 0, y: kMainBoundsHeight, width: kMainBoundsWidth, height: 220.0))
        giftView?.backgroundColor = UIColor.black
        giftView?.xm_giftDelagate = self
        ///MARK: 分享视图
        shareView = XM_ShareView.init(frame: CGRect.zero, imageArray: ["share_btn_qq","share_btn_pyq","share_btn_qzone","share_btn_wechat"], titleArray: ["QQ","朋友圈","QQ空间","微信"])
    }
}
///MARK: 键盘弹起回收
extension XM_LiveRoomViewController {
    
    @objc fileprivate  func keyBoardWillShow(_ note: Notification){         ///MARK: 键盘弹出
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - 44.0       /// 451 - 44.0
        let inputChatViewY = endFrame.origin.y - 180.0 - 10.0 
        UIView.animate(withDuration: duration) {
            self.chatView?.frame.origin.y = inputViewY
            self.xm_chatTableView.frame.origin.y = inputChatViewY
        }
    }
    @objc fileprivate  func keyBoardWillHide(_ note: Notification){           ///MARK: 键盘关闭
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y + 44.0       /// 661 + 44.0
        let inputChatViewY = endFrame.origin.y - 10.0 - 40.0 - 180.0 /// - 间隙 10 - 底部视图 40.0 - 自身高度 180.0
        
        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 2)!)
            self.chatView?.frame.origin.y = inputViewY
            self.xm_chatTableView.frame.origin.y = inputChatViewY
        }
    }
    @objc fileprivate  func keyboardWillChange(_ note: Notification){           ///MARK:TextView  随着文字高度变化而变化通知方法
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {         ///MARK: 关闭键盘
        self.chatView?.xm_chatTextView.resignFirstResponder()
    }
}

///MARK: 高斯模糊背景视图
extension XM_LiveRoomViewController{
    
    fileprivate func createBlurBackground (image:UIImage,view:UIView,blurRadius:Float) {
        let originImage = CIImage.init(cgImage: image.cgImage!)
        let filter = CIFilter.init(name: "CIGaussianBlur")
        filter?.setValue(originImage, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber.init(value: blurRadius), forKey: "inputRadius")
        let context = CIContext.init(options: nil)
        let result: CIImage = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let blurImage = UIImage.init(cgImage: context.createCGImage(result, from: result.extent)!)
        let blurImageView = UIImageView.init(frame: CGRect.init(x: -kMainBoundsWidth/2, y: -kMainBoundsHeight/2, width: kMainBoundsWidth*2, height: kMainBoundsHeight*2))   ///MARK: 加大聚焦点
        blurImageView.contentMode = .scaleAspectFill
        blurImageView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        blurImageView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        blurImageView.image = blurImage
        self.view.insertSubview(blurImageView, belowSubview: view)
    }
}
///MARK: 礼物连击效果
extension XM_LiveRoomViewController: XM_SendGiftDlegate{
    
    func XM_SendGift(xm_gift: XM_GiftModel) {
        print("发送礼物:\(xm_gift)")
        let msg = GSPChatMessage.init()
        msg.text = xm_gift.subject
        msg.senderChatID = "\(arc4random_uniform(5) + 1)"
        msg.senderName = "SHUMIN"
        
        let giftModel = GiftModel.init()    ///用户发送礼物模型
        giftModel.headImage = UIImage.init(named: "xm_Profile")
        giftModel.name = msg.senderName
        giftModel.giftImage = xm_gift.img2
        giftModel.giftName = msg.text
        giftModel.giftCount = 1
        
        let manager = AnimOperationManager.shared()
        manager?.parentView = self.view
        manager?.anim(withUserID: msg.senderChatID, model: giftModel, finishedBlock: { (result) in
            print("\(result)")
            guard result == true else { return }
            //            self.zipGiftImageView.setImage(with: URL.init(string: xm_gift.gUrl!), placeholderImage: nil)
        })
        ///添加到数组
        dataSource.append(giftModel)
        self.xm_chatTableView.reloadData()
        self.xm_chatTableView.scrollToRow(at:  IndexPath(row: dataSource.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
}

///MARK: 接入聊天
extension XM_LiveRoomViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(XM_GiftCell.self)) as? XM_GiftCell
        if cell == nil {
            cell = XM_GiftCell.init(style: UITableViewCellStyle.default, reuseIdentifier: NSStringFromClass(XM_GiftCell.self))
        }
        cell?.xm_giftModel = self.dataSource[indexPath.row]
        return cell!;
    }
    
}
