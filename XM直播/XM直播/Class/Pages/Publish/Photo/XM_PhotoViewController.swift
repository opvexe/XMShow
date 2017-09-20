//
//  XM_PhotoViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/9/6.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

///MARK: 自定义相机
import UIKit
import AVFoundation
import Photos
import AssetsLibrary

class XM_PhotoViewController: UIViewController {
    
    ///MARK: 顶部视图
    let upperView       = UIView.init()
    let flashBtn        = UIButton(type: .custom)   ///MARK: 闪光灯按钮
    let closeBtn        = UIButton(type: .custom)  ///MARK:关闭按钮
    let cramaBtn        = UIButton(type: .custom)  ///MARK:切换相机按钮
    
    ///MARK: 底部视图
    let bottomView      = UIView.init()
    let takePicBtn      = UIButton(type: .custom)   ///MARK: 拍照按钮
    let iamgeAlbumBtn   = UIButton(type: .custom)   ///MARK: 相册按钮
    
    ///MARK: 聚焦
    var deviceScale     = CGFloat() ///MARK: 聚焦缩放大小
    let reciveGesture   = UIView()  ///MARK: 触摸区域
    let focusView       = UIView()  ///MARK: 聚焦视图
    
    ///MARK: AVFoundation
    var captureSession:    AVCaptureSession? ///MARK: 会话
    var captureDevice:     AVCaptureDevice? ///MARK:  设备
    var captureConnection: AVCaptureConnection? ///MARK: 连接
    var preViewLayer:      AVCaptureVideoPreviewLayer? ///MARK: 预览层
    var deviceInput:       AVCaptureDeviceInput? ///MARK: 输入
    var imageOutPut:       AVCaptureStillImageOutput?///MARK: 输出
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        if cameraPermissions() == true {
            if photoPermissions() == true {
                ///MARK: 初始化UI界面
                setUpUI()
                ///MARK: 配置会话参数
                configSession()
                ///MARK: 添加手势
                addGesture()
                ///MARK: 获取缩略图
                self.getThumbnailImages()
            }else{
                print("相册权限没打开")
            }
        } else{
            print("相机权限没打开")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    ///MARK: 局部隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    ///MARK: 添加手势
    fileprivate func addGesture() {
        //聚焦
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(manuFaous(sender:)))
        self.reciveGesture.addGestureRecognizer(tapGesture)
        //放大
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomView(sender:)))
        self.reciveGesture.addGestureRecognizer(pinchGesture)
    }
    
    ///MARK: 获取相机相册权限
   fileprivate func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            return true
        }
    }
    
   fileprivate func photoPermissions() -> Bool{
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied , .restricted:
            return false
        case .authorized:
            return true
        case .notDetermined:
            let vc = UIImagePickerController()
            vc.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            return true
        }
    }
}

extension XM_PhotoViewController {
    fileprivate func getThumbnailImages() {     ///MARK: 获取相册缩略图 --数据
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        assetCollections.enumerateObjects({ (assetCollection, _, _) in
            self.enumerateAssetsInAssetCollection(assetCollection: assetCollection, original: false)
        })
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil).lastObject
        self.enumerateAssetsInAssetCollection(assetCollection: cameraRoll!, original: false)
    }
    
    fileprivate func enumerateAssetsInAssetCollection(assetCollection: PHAssetCollection, original: Bool) { ///MARK: 获取缩略图
        let options = PHImageRequestOptions.init()
        options.isSynchronous = true
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        assets.enumerateObjects({ (asset, _, _) in
            let  xm_size = CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight)
            PHImageManager.default().requestImage(for: asset, targetSize: xm_size, contentMode: .default, options: options, resultHandler: { (result, _: [AnyHashable : Any]?) in
                print("\(String(describing: result))")          ///MARK: 设置图片
                self.iamgeAlbumBtn.setImage(result, for: .normal)
            })
        })
    }
}
extension XM_PhotoViewController{  ///MARK: 初始化UI
    
    fileprivate func setUpUI()  {
        
        self.upperView.frame  = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 64.0)
        self.upperView.backgroundColor = UIColor.white
        self.view.addSubview(self.upperView)
        
        self.bottomView.frame = CGRect.init(x: 0, y: view.bounds.height - 100.0, width: view.bounds.width, height: 100.0)
        self.bottomView.backgroundColor = UIColor.white
        self.view.addSubview(self.bottomView)
        
        ///MARK: 顶部视图
        self.closeBtn.frame = CGRect.init(x: upperView.frame.width - 40.0 - 20.0, y: 12.0, width: 40.0, height: 40.0)
        self.closeBtn.tag   = 100
        self.closeBtn.setImage(UIImage.init(named: "btn_mv_top_close_full_b_37x37_"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        self.upperView.addSubview(self.closeBtn)
        
        self.cramaBtn.frame = CGRect.init(x: 20.0, y: 12.0, width: 40.0, height: 40.0)
        self.cramaBtn.tag   = 101
        self.cramaBtn.setImage(UIImage.init(named: "icon_btn_camera_flip_a_33x33_"), for: .normal)
        self.cramaBtn.setImage(UIImage.init(named: "icon_btn_camera_flip_b_33x33_"), for: .selected)
        self.cramaBtn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        self.upperView.addSubview(self.cramaBtn)
        
        self.flashBtn.frame = CGRect.init(x: self.cramaBtn.frame.maxX + 20.0, y: 12.0, width: 40.0, height: 40.0)
        self.flashBtn.tag   = 102
        self.flashBtn.setImage(UIImage.init(named: "icon_btn_camera_flash_on_a_33x33_"), for: .normal)
        self.flashBtn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        self.upperView.addSubview(self.flashBtn)
        
        ///MARK: 底部视图
        self.takePicBtn.frame = CGRect.init(x: view.center.x - 30.0 , y: 20.0, width: 60.0, height: 60.0)
        self.takePicBtn.tag   = 103
        self.takePicBtn.setImage(UIImage.init(named: "photo_take"), for: .normal)
        self.takePicBtn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        self.bottomView.addSubview(self.takePicBtn)
        
        self.iamgeAlbumBtn.frame = CGRect.init(x: 20.0, y: self.takePicBtn.center.y - 20.0, width: 40.0, height: 40.0)
        self.iamgeAlbumBtn.tag   = 104
        self.iamgeAlbumBtn.layer.masksToBounds = true
        self.iamgeAlbumBtn.layer.cornerRadius = 5.0
        //        self.iamgeAlbumBtn.setImage(UIImage.init(named: "photo_take"), for: .normal)
        self.iamgeAlbumBtn.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        self.bottomView.addSubview(self.iamgeAlbumBtn)
        
        ///MARK: 添加手势区域
        self.reciveGesture.frame = CGRect(x: 0, y: upperView.frame.maxY, width: self.view.frame.width, height: bottomView.frame.minY - upperView.frame.maxY)
        self.reciveGesture.backgroundColor = UIColor.clear
        self.view.addSubview(self.reciveGesture)
        
        ///MARK: 聚焦视图
        let focusImage = UIImage(named: "photo_point_m")        ///MARK: 手动聚焦
        self.focusView.frame = CGRect(x: 0, y: 0, width: focusImage!.size.width, height: focusImage!.size.height)
        self.focusView.isHidden = true
        self.focusView.layer.contents = focusImage!.cgImage as Any
        self.view.addSubview(self.focusView)
    }
}

extension XM_PhotoViewController {     ///MARK: 相机事件
    
    func photoAction(sender : UIButton) {
        
        switch sender.tag - 100 {
        case 0:
            dismiss(animated: true, completion: {})
        case 1:
            switchCarma()
        case 2:
            switchFlashMode()
        case 3:
            takePhoto()
        case 4:
            openAlbum()
        default:
            break
        }
    }
    
    ///MARK: 相机前后置
    fileprivate func switchCarma(){
        guard self.captureDevice != nil else {return}
        let currentPostion = self.captureDevice!.position
        var resultPostion = AVCaptureDevicePosition.unspecified
        switch currentPostion {
        case .unspecified:
            ()
        case .back:
            resultPostion = .front
        case .front:
            resultPostion = .back
        }
        
        let transition = CATransition()
        transition.type = "oglFlip"
        transition.duration = 0.5
        transition.subtype = resultPostion == .front ? kCATransitionFromLeft : kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.preViewLayer?.add(transition, forKey: nil)
        
        //开始配置
        self.captureSession?.beginConfiguration()
        self.captureSession?.removeInput(self.deviceInput!)
        let devices:[AVCaptureDevice] = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == resultPostion {
                self.captureDevice = device
                break
            }
        }
        try? self.deviceInput = AVCaptureDeviceInput(device: self.captureDevice)
        
        if self.captureSession!.canAddInput(self.deviceInput) {
            self.captureSession?.addInput(self.deviceInput)
        }
        self.captureSession?.commitConfiguration()
    }
    
    ///MARK: 闪光灯
    fileprivate  func switchFlashMode(){
        let flashMode = self.captureDevice!.flashMode
        var resultFlashModel = AVCaptureFlashMode.auto
        var infoTips = ""
        
        switch flashMode {
        case .off:
            resultFlashModel = .on
            infoTips = "icon_btn_camera_flash_on_a_33x33_"
        case .on:
            resultFlashModel = .auto
            infoTips = "btn_mv_top_flash_off_a_37x37_"
        case .auto:
            resultFlashModel = .off
            infoTips = "icon_btn_camera_flash_off_b_33x33_"
        }
        if self.captureDevice!.isFlashModeSupported(resultFlashModel) {
            do {
                try self.captureDevice!.lockForConfiguration()
                self.captureDevice?.flashMode = resultFlashModel
                self.captureDevice!.unlockForConfiguration()
                self.flashBtn.setImage(UIImage.init(named: infoTips), for: .normal)
            } catch  {
                print("错定失败")
            }
        }
    }
    
    ///MARK: 拍照
    fileprivate func takePhoto(){
        guard self.captureSession!.isRunning else {return}
        
        self.captureConnection = self.imageOutPut?.connection(withMediaType: AVMediaTypeVideo)
        self.captureConnection?.videoOrientation = .portrait
        self.captureConnection?.videoScaleAndCropFactor = 1.0
        self.captureSession?.startRunning()
        self.imageOutPut?.captureStillImageAsynchronously(from: self.captureConnection, completionHandler: { (imageDataSampleBuffer, error) in
            
            guard imageDataSampleBuffer != nil else {return}
            self.captureSession?.stopRunning()
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            let image = UIImage(data: imageData!)
            ///MARK: 纠正图片方向
            let rectifyImage = image?.fixOrientationWithImage(image: image!)
            if self.tosaveImageToAlbum(image: rectifyImage!) == true {
                self.captureSession?.startRunning()
                self.getThumbnailImages()
                print("图片保存成功")
            } else {
                self.captureSession?.startRunning()
                print("图片保存失败")
            }
        });
    }
    
    fileprivate  func openAlbum(){    ///MARK: 打开相册
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {return}
        let picker = XM_UIImagePickeViewController()            ///MARK: 重写  UIImagePicker
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true             /// ///Localized resources can be mixed 设置为 YES。 转换成中文
        picker.delegate = self
        self.captureSession?.stopRunning()
        picker.modalTransitionStyle = .crossDissolve
        self.present(picker, animated: true) {}
    }
}
extension XM_PhotoViewController {  ///MARK: 配置会话参数
    
    fileprivate func configSession() {
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        self.flashBtn.isHidden = !self.captureDevice!.isFlashAvailable
        
        do {
            try self.captureDevice!.lockForConfiguration()
            
            if  self.captureDevice!.isFlashModeSupported(.auto) {
                self.captureDevice!.flashMode = .auto
            }
            
            if self.captureDevice!.isFocusModeSupported(.continuousAutoFocus) {
                self.captureDevice!.focusMode = .continuousAutoFocus
            }
            
            if self.captureDevice!.isSmoothAutoFocusSupported {
                self.captureDevice!.isSmoothAutoFocusEnabled = true
            }
            
            if self.captureDevice!.isExposureModeSupported(.continuousAutoExposure) {
                self.captureDevice!.exposureMode = .continuousAutoExposure
            }
            
            
            if self.captureDevice!.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                self.captureDevice!.whiteBalanceMode = .autoWhiteBalance
            }
            self.captureDevice!.unlockForConfiguration()
            
        } catch  {
            print("设备锁定出错:\(error.localizedDescription)")
        }
        
        //设置输入
        self.deviceInput = try? AVCaptureDeviceInput(device: self.captureDevice!)
        //设置输出
        self.imageOutPut = AVCaptureStillImageOutput()
        self.imageOutPut?.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        //设置session
        self.captureSession = AVCaptureSession()
        if self.captureSession!.canSetSessionPreset(AVCaptureSessionPreset1280x720) {
            self.captureSession?.sessionPreset = AVCaptureSessionPreset1280x720
        }
        
        if self.captureSession!.canAddInput(self.deviceInput) {
            self.captureSession!.addInput(self.deviceInput)
        }
        
        if self.captureSession!.canAddOutput(self.imageOutPut) {
            self.captureSession?.addOutput(self.imageOutPut)
        }
        
        self.preViewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.preViewLayer?.frame = UIScreen.main.bounds
        self.preViewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(self.preViewLayer!, at: 0)
        
        self.captureSession?.startRunning()
    }
}

extension XM_PhotoViewController{           ///MARK: 相机权限
    
    fileprivate  func tosaveImageToAlbum(image:UIImage) -> Bool {        ///MARK: 保存图片到相册
        var isSuccess = false //保存到系统相册成败
        var assertId: String?
        do {
            try PHPhotoLibrary.shared().performChangesAndWait({
                let phasetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assertId = phasetRequest.placeholderForCreatedAsset?.localIdentifier
            })
        } catch let error {
            print("图片保存失败",error.localizedDescription)
        }
        
        isSuccess = true
        let phassets =  PHAsset.fetchAssets(withLocalIdentifiers: [assertId!], options: nil)
        if  let asetCollection = createAssetCollectionIfNeed() {
            do {
                try PHPhotoLibrary.shared().performChangesAndWait {
                    
                    let collectionChangeRequeset =  PHAssetCollectionChangeRequest(for: asetCollection)
                    collectionChangeRequeset?.insertAssets(phassets, at: IndexSet(integer: 0))
                }
            } catch  {
                print("图片保存失败")
            }
        }
        return isSuccess
    }
    
    fileprivate  func createAssetCollectionIfNeed() -> PHAssetCollection? {      ///MARK: 创建相册集合
        var assetCollection: PHAssetCollection?
        let name: String =  Bundle.main.infoDictionary![String(kCFBundleNameKey)] as! String
        let collections =  PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        collections.enumerateObjects({ (collection, _, _) in
            if collection.localizedTitle == name {
                assetCollection = collection
            }
        })
        if assetCollection != nil {
            return assetCollection
        }
        var collectionID:String?
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let collectionrequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            collectionID = collectionrequest.placeholderForCreatedAssetCollection.localIdentifier
        }
        assetCollection =  PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionID!], options: nil).firstObject
        return assetCollection
    }
}

extension XM_PhotoViewController {      ///MARK: 聚焦缩放手势
    
    func zoomView(sender:UIPinchGestureRecognizer) {        ///MARK: 缩放
        var scale: CGFloat = self.deviceScale + (sender.scale - 1)
        if scale > 5 {
            scale = 5
        } else if scale < 1 {
            scale = 1
        }
        self.setZoomScaleWithFactor(zoomScaleFactor: scale)
        if sender.state == .ended {
            self.deviceScale = scale
        }
    }
    
    func setZoomScaleWithFactor(zoomScaleFactor: CGFloat) {     ///MARK：设置缩放比例
        do {
            try self.captureDevice?.lockForConfiguration()
            self.captureDevice?.videoZoomFactor = zoomScaleFactor
            self.captureDevice?.unlockForConfiguration()
        } catch  {}
    }
    
    func manuFaous(sender:UITapGestureRecognizer) {         ///MARK:聚焦手势
        guard self.captureSession!.isRunning else {return}
        //将触摸点转换到预览层
        let devicePoint = self.preViewLayer?.captureDevicePointOfInterest(for: sender.location(in: self.view))
        do {
            try self.captureDevice?.lockForConfiguration()
            if self.captureDevice!.isFocusPointOfInterestSupported && self.captureDevice!.isFlashModeSupported(.auto) {
                self.captureDevice?.focusPointOfInterest = devicePoint!
                self.captureDevice?.focusMode = .autoFocus
            }
            if self.captureDevice!.isExposurePointOfInterestSupported && self.captureDevice!.isFlashModeSupported(.auto) {
                self.captureDevice?.exposurePointOfInterest = devicePoint!
                self.captureDevice?.exposureMode = .autoExpose
            }
            self.captureDevice?.unlockForConfiguration()
        } catch  {
            print("设备锁定失败:\(error.localizedDescription)")
        }
        //聚焦动画
        self.focusView.center = sender.location(in: self.view)
        self.focusView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)     ///MARK: 先放大后缩小
            self.focusView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (finished:Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.focusView.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.focusView.isHidden = true
            })
        }
    }
}

extension XM_PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{ ///MARK:  UIImagePickerControllerDelegate 调用相册带来事件
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage   ////MARK: 获取编辑后的图片
        guard (editedImage != nil) else {   return picker.dismiss(animated: true) {} }      ///MARK: 图片为空
        
        if editedImage?.imageOrientation != UIImageOrientation.up {
           let finnalImage = editedImage?.fixOrientationWithImage(image: editedImage!)            ///MARK: 翻转图片
        }else{
           
        }
        picker.pushViewController(XM_PublishDynamicViewController(), animated: true)
    }
}
