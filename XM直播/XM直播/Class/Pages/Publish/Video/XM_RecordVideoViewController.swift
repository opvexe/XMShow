//
//  XM_RecordVideoViewController.swift
//  XM直播
//
//  Created by GDBank on 2017/9/11.
//  Copyright © 2017年 com.GDBank.Company. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary


enum XMVideoViewType: Int {
    case TypeFullScreen = 0             ///MARK: 全屏
    case Type4X3                        ///MARK: 3/4
}

enum XMRecordState: Int {
    case XMRecordStateInit = 0         ///MARK: 初始化录制状态
    case XMRecordStatePrepareRecording ///MARK: 准备录制
    case XMRecordStateRecording        ///MARK: 正在录制
    case XMRecordStateFinish           ///MARK: 录制完成
    case XMRecordStateFail             ///MARK: 录制失败
}

private let MAX_RecordTime: CGFloat = 60.0                  ///MARK: 最大录制时长
private let TIMER_Interval: TimeInterval = 0.05             ///MARK: 定时器刷新频率
private let VIDEO_File: String  = "videoFile"               ///MARK: 视频文件
class XM_RecordVideoViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate{
    
    ///MARK: 视图控件
    let recordBtn       = UIButton(type: .custom)   ///MARK: 录制按钮
    let flashBtn        = UIButton(type: .custom)   ///MARK: 闪光灯按钮
    let closeBtn        = UIButton(type: .custom)  ///MARK:关闭按钮
    let cramaBtn        = UIButton(type: .custom)  ///MARK:切换相机按钮
    let resetBtn        = UIButton(type: .custom)  ///MARK:重置按钮
    let saveBtn         = UIButton(type: .custom)  ///MARK:存储按钮
    
    ///MARK: 音频视频会话类
    var captureSession:    AVCaptureSession? ///MARK: 会话
    var captureDevice:     AVCaptureDevice? ///MARK:  设备
    var captureConnection: AVCaptureConnection? ///MARK: 连接
    var preViewLayer:      AVCaptureVideoPreviewLayer? ///MARK: 预览层
    var videoInput:        AVCaptureDeviceInput?        ///MARK: 视频输入
    var audioInput:        AVCaptureDeviceInput?        ///MARK: 音频输入
    var videoOutput:       AVCaptureVideoDataOutput?    ///MARK: 视频输出
    var audioOutput:       AVCaptureAudioDataOutput?    ///MARK: 音频输出
    var assetWriterVideoInput: AVAssetWriterInput?      ///MARK: 视频写入
    var assetWriterAudioInput: AVAssetWriterInput?      ///MARK: 音频写入
    var assetWriter:        AVAssetWriter!
    var assetWriterPixelBufferInput: AVAssetWriterInputPixelBufferAdaptor?
    
    ///MARK: 聚焦
    let videoQueue      = DispatchQueue(label: "QueueCurrent", attributes: .concurrent)         ///MARK: 并发队列
    var rect            = CGRect.zero                      ///MARK: 视频的Frame
    var deviceScale     = CGFloat() ///MARK: 聚焦缩放大小
    let reciveGesture   = UIView()  ///MARK: 触摸区域
    let focusView       = UIView()  ///MARK: 聚焦视图
    
    ///MARK: 其他变量
    var recordState:    XMRecordState? ///MARK: 录制状态
    var videoUrl:       URL?        ///MARK: 视频地址
    var outputSize:     CGSize?     ///MARK: 尺寸
    var timer:          Timer?      ///MARK: 定时器
    var recordTime:     CGFloat?   ///MARK: 录制时间
    var canWrite:       Bool?      ///MARK: 是否能写入数据
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        NotificationCenter.default.addObserver(self, selector: #selector(enterBack), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        recordState = .XMRecordStateInit
        setUpUI()
        configVideo(VideoType: .TypeFullScreen)
        addGesture()
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
    
    ///MARK:获取文件路径
    fileprivate func videoFileName() -> NSString {
        let cacheDir = XM_FileManager.cachesDir() as NSString
        let direc = cacheDir.appendingPathComponent(VIDEO_File) as NSString
        if !XM_FileManager.isExists(atPath: direc as String!) {
            XM_FileManager.createFile(atPath: direc as String!)
        }
        return direc
    }
    
    deinit {            ///MARK: 销毁内存
        destroyWrite()
        NotificationCenter.default.removeObserver(self)
        print("dealloc == 内存释放 == ")
    }
}

extension XM_RecordVideoViewController{
    
    fileprivate  func setUpUI() {
        
        ///MARK: 添加手势区域
        self.reciveGesture.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.reciveGesture.backgroundColor = UIColor.clear
        self.view.addSubview(self.reciveGesture)
        
        ///MARK: 关闭按钮
        self.closeBtn.frame = CGRect.init(x: 20.0, y: 12.0, width: 40.0, height: 40.0)
        self.closeBtn.tag   = 100
        self.closeBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.closeBtn)
        
        ///MARK: 摄像头
        self.cramaBtn.frame = CGRect.init(x: view.frame.size.width - 60.0, y: 12.0, width: 40.0, height: 40.0)
        self.cramaBtn.tag   = 101
        self.cramaBtn.setImage(UIImage.init(named: "icon-fanhui"), for: .normal)
        self.cramaBtn.setImage(UIImage.init(named: "icon-fanhui"), for: .selected)
        self.cramaBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.cramaBtn)
        
        ///MARK: 闪光灯
        self.flashBtn.frame = CGRect.init(x: self.cramaBtn.frame.minX - 60.0, y: 12.0, width: 40.0, height: 40.0)
        self.flashBtn.tag   = 102
        self.flashBtn.setImage(UIImage.init(named: "listing_flash_on"), for: .normal)
        self.flashBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.flashBtn)
        
        ///MARK: 录制
        self.recordBtn.frame = CGRect.init(x: view.center.x - 40.0 , y: view.frame.height - 120.0, width: 80.0, height: 80.0)
        self.recordBtn.tag   = 103
        self.recordBtn.setImage(UIImage.init(named: "icon-paizhao"), for: .normal)
        self.recordBtn.setImage(UIImage.init(named: "icon-one"), for: .selected)
        self.recordBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.recordBtn)
        
        ///MARK: 重置
        self.resetBtn.frame = CGRect.init(x: self.recordBtn.frame.minX - 100.0 , y: view.frame.height - 120.0, width: 80.0, height: 80.0)
        self.resetBtn.tag   = 104
        self.resetBtn.isHidden = true
        self.resetBtn.setImage(UIImage.init(named: "icon-oneBack"), for: .normal)
        self.resetBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.resetBtn)
        
        ///MARK: 保存
        self.saveBtn.frame = CGRect.init(x: self.recordBtn.frame.maxX + 40.0 , y: view.frame.height - 120.0, width: 80.0, height: 80.0)
        self.saveBtn.tag   = 105
        self.saveBtn.isHidden  = true
        self.saveBtn.setImage(UIImage.init(named: "icon-three"), for: .normal)
        self.saveBtn.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        self.reciveGesture.addSubview(self.saveBtn)
        
        let focusImage = UIImage(named: "photo_point_m")        ///MARK: 手动聚焦
        self.focusView.frame = CGRect(x: 0, y: 0, width: focusImage!.size.width, height: focusImage!.size.height)
        self.focusView.isHidden = true
        self.focusView.layer.contents = focusImage!.cgImage as Any
        self.reciveGesture.addSubview(self.focusView)
    }
}

extension XM_RecordVideoViewController {
    
    func recordAction(sender: UIButton)  {
        
        switch sender.tag - 100 {
        case 0:
            dismiss(animated: true, completion: {})
        case 1:
            switchCarma()
        case 2:
            switchFlashMode()
        case 3:
            startRecord()
            self.resetBtn.isHidden = false
            self.saveBtn.isHidden = false
        case 4:
            reset()
        case 5:
            stopRecord()
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
        self.captureSession?.removeInput(self.videoInput!)
        let devices:[AVCaptureDevice] = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == resultPostion {
                self.captureDevice = device
                break
            }
        }
        
        ///MARK:  AVCaptureDeviceInput 输入
        let newInput  = try?AVCaptureDeviceInput.init(device: self.captureDevice)
        self.captureSession?.addInput(newInput)
        self.videoInput = newInput
        self.captureSession?.commitConfiguration()
        self.captureSession?.startRunning()
    }
    
    ///MARK: 闪光灯
    fileprivate  func switchFlashMode(){
        let flashMode = self.captureDevice!.flashMode
        var resultFlashModel = AVCaptureFlashMode.auto
        var infoTips = ""
        
        switch flashMode {
        case .off:
            resultFlashModel = .on
            infoTips = "listing_flash_on"
        case .on:
            resultFlashModel = .auto
            infoTips = "listing_flash_auto"
        case .auto:
            resultFlashModel = .off
            infoTips = "listing_flash_off"
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
    
    fileprivate  func startRecord() {  ///MARK: 开始录制
        if self.recordState == .XMRecordStateInit {
            if !(self.assetWriter != nil) {
                setAttributeWriter()
            }
        }
    }
    
    fileprivate func stopRecord() {      ///MARK: 停止录制
        self.recordState = .XMRecordStateFinish
        self.captureSession?.stopRunning()
        stopWrite()
    }
    
    fileprivate func reset() {           ///MARK: 重置录制
        self.recordState = .XMRecordStateInit
        self.captureSession?.startRunning()
        setAttributeWriter()
    }
    
    
    @objc fileprivate func enterBack() {   ///MARK: 进入后台
        
    }
    @objc fileprivate func becomeActive() {   ///MARK: 进入前台
        
    }
    
    
    
    @objc fileprivate func updateProgress() {
        
    }
}

extension XM_RecordVideoViewController {      ///MARK: 聚焦缩放手势
    
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

extension XM_RecordVideoViewController {
    
    fileprivate func configVideo(VideoType: XMVideoViewType) {               ///MARK: 设置视频的输入输出
        
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
        
        //设置session
        self.captureSession = AVCaptureSession.init()
        if self.captureSession!.canSetSessionPreset(AVCaptureSessionPreset640x480) {
            self.captureSession?.sessionPreset = AVCaptureSessionPreset640x480
        }
        ///MARK: 创建视频输入源
        self.videoInput = try? AVCaptureDeviceInput(device: self.captureDevice!)
        
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio) as! [AVCaptureDevice]
        self.audioInput = try? AVCaptureDeviceInput(device: devices.first)
        
        
        self.videoOutput = AVCaptureVideoDataOutput.init()
        self.videoOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString: kCVPixelFormatType_32BGRA]
        self.videoOutput?.alwaysDiscardsLateVideoFrames = true ///MARK: 立即丢弃旧帧，节省内存，默认YES
        self.videoOutput?.setSampleBufferDelegate(self, queue: self.videoQueue)
        
        self.audioOutput = AVCaptureAudioDataOutput.init()
        self.audioOutput?.setSampleBufferDelegate(self, queue: self.videoQueue)
        
        
        if self.captureSession!.canAddOutput(self.videoOutput) {
            self.captureSession!.addOutput(self.videoOutput)
        }
        
        
        if self.captureSession!.canAddOutput(self.audioOutput) {
            self.captureSession!.addOutput(self.audioOutput)
        }
        
        ///MARK: 将视频输入源添加到会话
        if self.captureSession!.canAddInput(self.videoInput) {
            self.captureSession!.addInput(self.videoInput)
        }
        
        if self.captureSession!.canAddInput(self.audioInput) {
            self.captureSession!.addInput(self.audioInput)
        }
        
        ///MARK: 预览层
        switch VideoType {
        case .TypeFullScreen:
            rect = UIScreen.main.bounds
            outputSize = CGSize.init(width: view.frame.width, height: view.frame.height)
        case .Type4X3:
            rect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*4/3)
            outputSize = CGSize.init(width: view.frame.width, height: view.frame.width*4/3)
        }
        self.preViewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        self.preViewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preViewLayer?.frame = rect
        self.view.layer.insertSublayer(self.preViewLayer!, at: 0)
        ///MARK: 开始采集画面
        self.captureSession?.startRunning()
    }
}

extension XM_RecordVideoViewController {            ///MARK: AVCaptureVideoDataOutputSampleBufferDelegate代理方法
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        print("录制中assetWriter = status: == \(String(describing: self.assetWriter?.status.rawValue))")
        
            if self.assetWriter?.status != .writing {
                self.assetWriter?.startWriting()
                self.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
            }else{
                if captureOutput == self.videoOutput {   ///MARK: 视频
                    if (self.assetWriterPixelBufferInput?.assetWriterInput.isReadyForMoreMediaData)! {
                        
                        let  pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
                        let  pendingResult = self.assetWriterPixelBufferInput?.append(pixelBuffer!, withPresentationTime: CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer))
                        
                        if pendingResult! {
                            print("susess")
                        }else{
                            print(" faild")
                        }
                    }
                }else{
                    print("videoOutput erorr")
                }
                
                if captureOutput == self.audioOutput {
                    if (self.assetWriterAudioInput?.isReadyForMoreMediaData)! {
                        self.assetWriterAudioInput?.append(sampleBuffer)
                    }
                }else{
                    print("audioOutput erorr")
                }
                
                return
            }
        }
}

extension XM_RecordVideoViewController {
    fileprivate func setAttributeWriter() {          ///MARK: 视频参数属性
        
        guard XM_FileManager.clearCachesDirectory() else { return }
        let path = XM_FileManager.cachesDir() as NSString
        let direc = path.appendingPathComponent("XMZB") as NSString
        
        if !XM_FileManager.isExists(atPath: direc as String!) {
            XM_FileManager.createDirectory(atPath: direc as String!)
        }
        let dateString = NSString.init(format: "%d.mov", getCurrentTimeStamp())
        let xm_path = direc.appendingPathComponent(dateString as String)
        videoUrl = URL.init(fileURLWithPath:xm_path)
        
        print("视频文件路径:== \(xm_path)")
        self.assetWriter = try? AVAssetWriter.init(outputURL: videoUrl!, fileType: AVFileTypeQuickTimeMovie)
        
        
        let outputSettings = [
            AVVideoCodecKey : AVVideoCodecH264,
            AVVideoWidthKey : CGFloat((self.outputSize?.height)!),
            AVVideoHeightKey : CGFloat((self.outputSize?.width)!),
            AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill] as [String : Any]
        
        self.assetWriterVideoInput = AVAssetWriterInput.init(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
        //expectsMediaDataInRealTime 必须设为yes，需要从capture session 实时获取数据
        self.assetWriterVideoInput?.expectsMediaDataInRealTime = true
        self.assetWriterVideoInput?.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI / 2.0))
        
        let audioOutputSettings = [
            AVFormatIDKey:kAudioFormatMPEG4AAC,
            AVEncoderBitRateKey:64000,
            AVSampleRateKey:44100,
            AVNumberOfChannelsKey:1]
        
        self.assetWriterAudioInput = AVAssetWriterInput.init(mediaType: AVMediaTypeAudio, outputSettings: audioOutputSettings)
        self.assetWriterAudioInput?.expectsMediaDataInRealTime = true
        
        let SPBADictionary = [
            kCVPixelBufferPixelFormatTypeKey as NSString : kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as NSString: CGFloat((self.outputSize?.width)!),
            kCVPixelBufferHeightKey as NSString: CGFloat((self.outputSize?.height)!),
            kCVPixelFormatOpenGLESCompatibility as NSString : kCFBooleanTrue as NSNumber] as [NSString : Any]
        
        self.assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor.init(assetWriterInput: self.assetWriterVideoInput!, sourcePixelBufferAttributes: SPBADictionary as [String : Any])
        
        if (self.assetWriter?.canAdd(self.assetWriterVideoInput!))! {
            self.assetWriter?.add(self.assetWriterVideoInput!)
        }else{
            print("AssetWriter videoInput append Failed")
        }
        
        if (self.assetWriter?.canAdd(self.assetWriterAudioInput!))! {
            self.assetWriter?.add(self.assetWriterAudioInput!)
        }else{
            print("AssetWriter audioInput Append Failed")
        }
        print("writer = status: \(String(describing: self.assetWriter?.status.rawValue))")  ///status = 1 正常可录制
        self.recordState = .XMRecordStateRecording
    }
}


extension XM_RecordVideoViewController{      ///MARK: 写入数据
    
    fileprivate func stopWrite() {           ///MARK: 停止写入数据
        self.timer?.invalidate()
        self.timer = nil
        
        print("status:== \(String(describing: self.assetWriter?.status.rawValue))")
        if (self.assetWriter != nil) && self.assetWriter?.status == .writing {
            DispatchQueue.global().async {
                self.assetWriter?.finishWriting(completionHandler: {
                    ALAssetsLibrary.init().writeVideoAtPath(toSavedPhotosAlbum: self.videoUrl, completionBlock: nil)
                })
            }
        }
    }
    
    fileprivate func destroyWrite() {       ///MARK: 销毁写入数据
        self.assetWriter = nil
        self.assetWriterAudioInput = nil
        self.assetWriterVideoInput = nil
        self.videoUrl = nil
        self.recordTime = 0
        self.timer?.invalidate()
        self.timer = nil
    }
}
