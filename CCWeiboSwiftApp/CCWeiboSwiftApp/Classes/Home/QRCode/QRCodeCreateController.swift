//
//  QRCodeCreateController.swift
//  CCWeiboSwiftApp
//
//  Created by Chester Chen on 2016/11/28.
//  Copyright © 2016年 Chen Chen. All rights reserved.
//

import UIKit

import Cartography

class QRCodeCreateController: UIViewController {

    /// 用户图片视图
    var customImageView = UIImageView()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        filterImage()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        view.addSubview(customImageView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(customImageView) { customImageView in
            customImageView.width == 300
            customImageView.height == 300
            customImageView.center == customImageView.superview!.center
        }
    }
    
    /**
     滤镜添加二维码方法
     */
    private func filterImage() {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        guard let userName = UserAccount.loadUserAccount()!.screenName else {
            return
        }
        
        filter?.setValue(userName.data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        guard let ciImage = filter?.outputImage else {
            return
        }
        
        customImageView.image = createHighDefinitionUIImageForCIImage(image: ciImage, size: 500)
    }
    
    /**
     生成高清二维码方法
     */
    private func createHighDefinitionUIImageForCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size / extent.width, size / extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: 0)!
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }

}
