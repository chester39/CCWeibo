//
//	iOS培训
//		小码哥
//		Chen Chen @ July 25th, 2016
//

import Foundation
import UIKit

extension UIButton {
    
    /**
     图片和背景图片便利初始化方法
     */
    convenience init(imageName: String?, backgroundImageName: String?) {
        
        self.init()
        
        if let name = imageName {
            setImage(UIImage(named: name), forState: UIControlState.Normal)
            setImage(UIImage(named: name + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
        if let backgroundName = backgroundImageName {
            setBackgroundImage(UIImage(named: backgroundName), forState: UIControlState.Normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), forState: UIControlState.Highlighted)
        }
        
        sizeToFit()
    }
    
}

extension UIBarButtonItem {
    
    /**
     指定图片便利初始化方法
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        self.init(customView: button)
    }
    
}

extension UIColor {
    
    /**
     十六进制颜色便利初始化方法
     */
    convenience init(hex: Int) {
        
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     十六进制透明度颜色便利初始化方法
     */
    convenience init(hex: Int, alpha: CGFloat) {
        
        self.init(red: (CGFloat)((hex & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((hex & 0x00FF00) >> 8) / 255.0, blue: (CGFloat)((hex & 0x0000FF) >> 0) / 255.0, alpha: alpha)
    }
}

extension String {
    
    /**
     获取缓存目录方法
     */
    func acquireCachesDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    
    /**
     获取文档目录方法
     */
    func acquireDocumentDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)

        return filePath
    }
    
    /**
     获取临时目录方法
     */
    func acquireTemporaryDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    
}
