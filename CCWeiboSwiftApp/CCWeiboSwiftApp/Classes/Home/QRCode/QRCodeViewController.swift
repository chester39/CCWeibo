//
//  QRCodeViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 28th, 2016
//

import UIKit
import AVFoundation

import Cartography

class QRCodeViewController: UIViewController {
    
    /// 二维码视图
    var qrCodeView = QRCodeView(frame: kScreenFrame)
    
    /// 视频流输入
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    /// 视频流输出
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
    
    /// 视频流会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    /// 视频流预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    /// 视频流描边图层
    fileprivate lazy var containerLayer: CALayer = CALayer()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = qrCodeView
        
        navigationController?.navigationBar.barTintColor = CommonDarkColor
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: CommonLightColor]
        navigationItem.title = "扫一扫"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(albumButtonDidClick))
        
        qrCodeView.tabBar.delegate = self
        qrCodeView.cardButton.addTarget(self, action: #selector(cardButtonDidClick), for: .touchUpInside)
        
        scanQRCode()
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(_ animated: Bool) {
        
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
        output.setMetadataObjectsDelegate(self, queue: .main)
        
        view.layer.insertSublayer(previewLayer, at: 0)
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
        
        dismiss(animated: false, completion: nil)
    }
    
    /**
     相册按钮点击方法
     */
    func albumButtonDidClick() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    /**
     名片按钮点击方法
     */
    func cardButtonDidClick() {
        
        let qrCodeCreateVC = QRCodeCreateController()
        navigationController?.pushViewController(qrCodeCreateVC, animated: false)
    }
    
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /**
     照片控制器选择多媒体方法
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        let resultArray = detector!.features(in: ciImage)
        for result in resultArray {
            print((result as! CIQRCodeFeature).messageString!)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

}

extension QRCodeViewController: UITabBarDelegate {
    
    /**
     点击底部工具栏方法
     */
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
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
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        guard let result = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        qrCodeView.textLabel.text = result.stringValue
        clearLayerLines()
        
        guard let metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        
        let object = previewLayer.transformedMetadataObject(for: metadata)
        drawLayerLines(object: object as! AVMetadataMachineReadableCodeObject)
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
        layer.strokeColor = QRCodeBorderColor.cgColor
        layer.fillColor = ClearColor.cgColor
        
        let path = UIBezierPath()
        var index = 0
        var point = CGPoint.zero
        point = CGPoint(dictionaryRepresentation: (array[index] as! CFDictionary))!
        index += 1
        path.move(to: point)
        while index < array.count {
            point = CGPoint(dictionaryRepresentation: (array[index] as! CFDictionary))!
            index += 1
            path.addLine(to: point)
        }
        
        path.close()
        layer.path = path.cgPath
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
