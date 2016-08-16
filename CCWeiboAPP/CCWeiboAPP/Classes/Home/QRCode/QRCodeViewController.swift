//
//	iOS培训
//		小码哥
//		Chen Chen @ August 12th, 2016
//

import UIKit
import AVFoundation
import Cartography

class QRCodeViewController: UIViewController {
    
    // 二维码视图
    var qrCodeView = QRCodeView(frame: kScreenFrame)
    
    // 视频流输入懒加载
    private lazy var input: AVCaptureDeviceInput? = {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    // 视频流会话懒加载
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 视频流输出懒加载
    private lazy var output: AVCaptureMetadataOutput = {
        
        let out = AVCaptureMetadataOutput()
        
        let viewFrame = self.view.frame
        let containerFrame = self.qrCodeView.containerView.frame
        let x = containerFrame.origin.y / viewFrame.size.height
        let y = containerFrame.origin.x / viewFrame.size.width
        let width = containerFrame.size.height / viewFrame.height
        let height = containerFrame.size.width / viewFrame.width
        
        return out
    }()
    
    // 视频流预览图层懒加载
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    // 视频流描边图层懒加载
    private lazy var containerLayer: CALayer = CALayer()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = qrCodeView
        
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(19), NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationItem.title = "扫一扫"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(albumButtonDidClick))
        
        qrCodeView.tabBar.delegate = self
        qrCodeView.cardButton.addTarget(self, action: #selector(cardButtonDidClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        scanQRCode()
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        qrCodeView.startAnimation()
    }
    
    // MARK: - 界面方法
    
    /**
     扫描二维码方法
     */
    private func scanQRCode() {
        
        if session.canAddInput(input) == false {
            return
        }
        
        if session.canAddOutput(output) == false {
            return
        }
        
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.frame = view.bounds
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        session.startRunning()
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     相册按钮点击方法
     */
    func albumButtonDidClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == false {
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    /**
     名片按钮点击方法
     */
    func cardButtonDidClick() {
        
        let qrccVC = QRCodeCreateViewController()
        navigationController?.pushViewController(qrccVC, animated: true)
    }
    
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /**
     照片控制器选择多媒体方法
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        let resultArray = detector.featuresInImage(ciImage)
        for result in resultArray {
            print((result as! CIQRCodeFeature).messageString)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension QRCodeViewController: UITabBarDelegate {
    
    /**
     点击底部工具栏方法
     */
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        qrCodeView.textLabel.text = (item.title == "条形码") ? "将条形码放入框内, 即可扫描条形码" : "将二维码放入框内, 即可扫描二维码"
        view.layoutIfNeeded()
        
        qrCodeView.waveView.layer.removeAllAnimations()
        qrCodeView.startAnimation()
    }
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    /**
     扫描输出方法
     */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        qrCodeView.textLabel.text = metadataObjects.last?.stringValue
        clearLayerLines()
        
        guard let metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        
        let object = previewLayer.transformedMetadataObjectForMetadataObject(metadata)
        drawLayerLines(object as! AVMetadataMachineReadableCodeObject)
    }
    
    /**
     绘制描边方法
     */
    private func drawLayerLines(object: AVMetadataMachineReadableCodeObject) {
        
        guard let array = object.corners else {
            return
        }
        
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        let path = UIBezierPath()
        var index = 0
        var point = CGPointZero
        CGPointMakeWithDictionaryRepresentation((array[index] as! CFDictionary), &point)
        index += 1
        path.moveToPoint(point)
        while index < array.count {
            CGPointMakeWithDictionaryRepresentation((array[index] as! CFDictionary), &point)
            index += 1
            path.addLineToPoint(point)
        }
        
        path.closePath()
        layer.path = path.CGPath
        containerLayer.addSublayer(layer)
    }
    
    /**
     清空描边方法
     */
    private func clearLayerLines() {
        
        guard let subLayers = containerLayer.sublayers else {
            return
        }
        
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
    
}