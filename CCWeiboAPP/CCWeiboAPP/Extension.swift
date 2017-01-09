//
//	Extension.swift
//		CCWeiboAPP
//		Chen Chen @ July 25th, 2016
//

import Foundation
import UIKit

import MBProgressHUD

extension NSDate {
    
    /**
     字符串创建日期方法
     */
    class func convertStringToDate(timeString: String, formatterString: String) -> NSDate  {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterString
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        return formatter.dateFromString(timeString)!
    }
    
    /**
     格式化字符串方法
     */
    class func formatDateToString(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        let nowDate = NSDate()
        let time = nowDate.timeIntervalSinceDate(date)
        var dateString = ""
        
        switch time {
        case 0...60:
            dateString = "刚刚"
            
        case 61...(60 * 60):
            let minute = (Int)(time / 60)
            dateString = "\(minute)分钟前"
            
        case (60 * 60)...(60 * 60 * 24):
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateDayString = dateFormatter.stringFromDate(date)
            let nowDayString = dateFormatter.stringFromDate(nowDate)
            
            dateFormatter.dateFormat = "HH:mm"
            if dateDayString == nowDayString {
                dateString = "今天\(dateFormatter.stringFromDate(date))"
                
            } else {
                dateString = "昨天\(dateFormatter.stringFromDate(date))"
            }
            
        default:
            dateFormatter.dateFormat = "yyyy"
            let dateYearString = dateFormatter.stringFromDate(date)
            let nowYearString = dateFormatter.stringFromDate(nowDate)
            
            if dateYearString == nowYearString {
                dateFormatter.dateFormat = "MM-dd"
                dateString = dateFormatter.stringFromDate(date)
                
            } else {
                dateFormatter.dateFormat = "yyyy/MM/dd"
                dateString = dateFormatter.stringFromDate(date)
            }
        }
        
        return dateString
    }
    
    /**
     获取指定天前字符串方法
     */
    class func acquireAssignedDaysAgo(number: NSTimeInterval, formatterString: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterString
        let nowDate = NSDate()
        let aDay: NSTimeInterval = 60 * 60 * 24
        let daysAgo = NSDate(timeInterval: -(number * aDay), sinceDate: nowDate)
        let daysAgoString = formatter.stringFromDate(daysAgo)
        
        return daysAgoString
    }
    
}

extension NSMutableAttributedString {
    
    /**
     改变部分文字颜色方法
     */
    class func changeColorWithString(color: UIColor, totalString: String, subString: String) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: totalString)
        let range = (totalString as NSString).rangeOfString(subString, options: .BackwardsSearch)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        return attributedString
    }
    
}

extension String {
    
    /**
     获取缓存目录方法
     */
    func acquireCachesDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    
    /**
     获取文档目录方法
     */
    func acquireDocumentDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    
    /**
     获取临时目录方法
     */
    func acquireTemporaryDirectory() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).stringByAppendingPathComponent(name)
        
        return filePath
    }
    
    /**
     调整数字表示方法
     */
    func adjustDigitalRepresentation() -> String {
        
        let length = characters.count
        if length > 5 {
            let oldNumber = Float(self)! / 1000
            let newNumber = lroundf(oldNumber)
            let newString = String(newNumber)
            return newString + "k"
            
        } else {
            return self
        }
    }
    
}

extension UIButton {
    
    /**
     图片和背景图片便利初始化方法
     */
    convenience init(imageName: String?, backgroundImageName: String?) {
        
        self.init()
        
        if let name = imageName {
            setImage(UIImage(named: name), forState: .Normal)
            setImage(UIImage(named: name + "_highlighted"), forState: .Highlighted)
        }
        
        if let backgroundName = backgroundImageName {
            setBackgroundImage(UIImage(named: backgroundName), forState: .Normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), forState: .Highlighted)
        }
        
        sizeToFit()
    }
    
}

extension UIBarButtonItem {
    
    /**
     指定图片和目标便利初始化方法
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
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

extension UIImage {
    
    /**
     图片染色方法
     */
    func tintImageWithColor(color: UIColor, alpha: CGFloat) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
        let context = UIGraphicsGetCurrentContext()
        drawInRect(rect)
        
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextSetAlpha(context!, alpha)
        CGContextSetBlendMode(context!, .SourceAtop)
        CGContextFillRect(context!, rect)
        
        let imageRef = CGBitmapContextCreateImage(context!)!
        let newImage = UIImage(CGImage: imageRef, scale: scale, orientation: imageOrientation)
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     重叠图片方法
     */
    func overlapImageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(size)
        colorImage!.drawInRect(rect)
        drawInRect(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

extension UILabel {
    
    /**
     文字和字号和行数便利初始化方法
     */
    convenience init(text: String, fontSize: CGFloat, lines: Int) {
        
        self.init()
        
        self.text = text
        font = UIFont.systemFontOfSize(fontSize)
        numberOfLines = lines
    }
}

extension UITextView {
    
    /**
     插入表情方法
     */
    func insertEmoticon(emoticon: EmoticonModel) {
        
        if let emojiString = emoticon.emojiString {
            let range = selectedTextRange!
            replaceRange(range, withText: emojiString)
            
            return
        }
        
        if let pngPath = emoticon.pngPath {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            
            let attachment = EmoticonAttachment()
            let fontHeight = font!.lineHeight
            attachment.emoticonChs = emoticon.chs
            attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
            attachment.image = UIImage(contentsOfFile: pngPath)
            let imageAttributedString = NSAttributedString(attachment: attachment)
            
            let range = selectedRange
            attributedString.replaceCharactersInRange(range, withAttributedString: imageAttributedString)
            attributedText = attributedString
            
            selectedRange = NSRange(location: range.location + 1, length: 0)
            font = UIFont.systemFontOfSize(18)
            
            return
        }
        
        if emoticon.isRemoveButton {
            deleteBackward()
        }
    }
    
    /**
     获取表情文字方法
     */
    func acquireEmoticonString() -> String {
        
        let range = NSRange(location: 0, length: attributedText.length)
        var string = ""
        
        attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                string += attachment.emoticonChs!
                
            } else {
                string += (self.text as NSString).substringWithRange(range)
            }
        }
        
        return string
    }
    
}

extension UIView {
    
    /**
     获取缓存大小方法
     */
    func acquireCachesSize() -> Float {
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        let fileAttributes = NSFileManager.defaultManager().subpathsAtPath(cachePath)!
        var size = 0
        for fileName in fileAttributes {
            let path = cachePath.stringByAppendingString("/\(fileName)")
            let attributes = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
            for (numberA, numberB) in attributes {
                if numberA == NSFileSize {
                    size += numberB as! Int
                }
            }
        }
        
        let mb: Float = Float(size) / 1024 / 1024
        
        return mb
    }
    
    /**
     清除缓存方法
     */
    func clearCaches() {
     
        let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        let fileAttributes = NSFileManager.defaultManager().subpathsAtPath(cachePath)!
        for fileName in fileAttributes {
            let path = cachePath.stringByAppendingString("/\(fileName)")
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                    
                } catch {
                    print("清除缓存失败")
                }
            }
        }
    }
    
}

extension UIWindow {
    
    /**
     判断是否浅色方法
     */
    class func isLightColor(string: String) -> Bool {
        
        let redString = (string as NSString).substringWithRange(NSRange(location: 1, length: 2))
        let greenString = (string as NSString).substringWithRange(NSRange(location: 3, length: 2))
        let blueString = (string as NSString).substringWithRange(NSRange(location: 5, length: 2))
        
        var scanner = NSScanner(string: redString)
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0
        scanner.scanHexInt(&red)
        scanner = NSScanner(string: greenString)
        scanner.scanHexInt(&green)
        scanner = NSScanner(string: blueString)
        scanner.scanHexInt(&blue)
        
        if (red + blue + green) < 382 {
            return false
            
        } else {
            return true
        }
    }
    
}

extension MBProgressHUD {
    
    /**
     显示消息和持续时间方法
     */
    class func showMessage(text: String, delay: NSTimeInterval) {
        
        let mainWindow = UIApplication.sharedApplication().keyWindow ?? UIApplication.sharedApplication().windows.first!
        let hud = MBProgressHUD.showHUDAddedTo(mainWindow, animated: true)
        hud.mode = .Text
        hud.label.text = text
        hud.hideAnimated(true, afterDelay: delay)
    }
}
