//
//	iOS培训
//		小码哥
//		Chen Chen @ August 16th, 2016
//

import UIKit

import Cartography

class QRCodeCreateController: UIViewController {

    // 用户图片视图
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
        
        constrain(customImageView) { (customImageView) in
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
        filter?.setValue("阇梨".dataUsingEncoding(NSUTF8StringEncoding), forKeyPath: "InputMessage")
        guard let ciImage = filter?.outputImage else {
            return
        }
        
        customImageView.image = createHighDefinitionUIImageForCIImage(ciImage, size: 500)
    }
    
    /**
     生成高清二维码方法
     */
    private func createHighDefinitionUIImageForCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent))
        
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let colorSpaceRef: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpaceRef, 0)!
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
}
