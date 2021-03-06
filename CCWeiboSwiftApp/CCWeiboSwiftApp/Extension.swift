//
//	Extension.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 15th, 2016
//

import Foundation
import UIKit

import MBProgressHUD

extension Date {

    /**
     字符串创建日期方法
     */
    func convertToDate(timeString: String, formatterString: String) -> Date  {

        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        formatter.locale = Locale(identifier: "en")
        let date = formatter.date(from: timeString)!

        return date
    }

    /**
     格式化字符串方法
     */
    func formatToString(date: Date) -> String {

        let formatter = DateFormatter()
        let nowDate = Date()
        let time = nowDate.timeIntervalSince(date)
        var dateString = ""

        switch time {
        case 0...60:
            dateString = "刚刚"

        case 61...(60 * 60):
            let minute = (Int)(time / 60)
            dateString = "\(minute)分钟前"

        case (60 * 60)...(60 * 60 * 24):
            formatter.dateFormat = "yyyy/MM/dd"
            let dateDayString = formatter.string(from: date)
            let nowDayString = formatter.string(from: nowDate)

            formatter.dateFormat = "HH:mm"
            if dateDayString == nowDayString {
                dateString = "今天\(formatter.string(from: date))"

            } else {
                dateString = "昨天\(formatter.string(from: date))"
            }

        default:
            formatter.dateFormat = "yyyy"
            let dateYearString = formatter.string(from: date)
            let nowYearString = formatter.string(from: nowDate)

            if dateYearString == nowYearString {
                formatter.dateFormat = "MM-dd"
                dateString = formatter.string(from: date)

            } else {
                formatter.dateFormat = "yyyy/MM/dd"
                dateString = formatter.string(from: date)
            }
        }

        return dateString
    }
    
    /**
     获取指定天前字符串方法
     */
    func assignedDaysAgo(number: TimeInterval, formatterString: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        let nowDate = Date()
        let aDay: TimeInterval = 60 * 60 * 24
        let daysAgo = Date(timeInterval: -(number * aDay), since: nowDate)
        let daysAgoString = formatter.string(from: daysAgo)

        return daysAgoString
    }
    
    /**
     获取今天星期几方法
     */
    func acquireTodayOfWeek() -> Int {
        
        let calender = Calendar(identifier: .gregorian)
        let component = calender.component(.weekday, from: self)
        
        return component
    }

}

extension NSMutableAttributedString {
    
    /**
     改变部分文字颜色方法
     */
    func changeColor(color: UIColor, totalString: String, subString: String) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: totalString)
        let range = (totalString as NSString).range(of: subString, options: .backwards)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        return attributedString
    }
    
    /**
     改变部分文字行间距方法
     */
    func changeLineSpacing(spacing: CGFloat, totalString: String, subString: String) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: totalString)
        let range = (totalString as NSString).range(of: subString, options: .backwards)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        
        return attributedString
    }
    
}

extension String {

    /**
     获取缓存目录方法
     */
    func cachesDirectory() -> String {

        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)

        return filePath
    }

    /**
     获取文档目录方法
     */
    func documentDirectory() -> String {

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)

        return filePath
    }

    /**
     获取临时目录方法
     */
    func temporaryDirectory() -> String {

        let path = NSTemporaryDirectory()
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)

        return filePath
    }
    
    /**
     调整数字表示方法
     */
    func digitalRepresentation(number: Int) -> String {
        
        var number = number
        number = number > 0 ? number : 0
        var string = ""
        
        if number > 10000 {
            string = "\(number)"
            
        } else {
            var postfix = "kw"
            var representation: Float = 10000000
            if number < 10000000 {
                postfix = "w"
                representation = 10000
            }
            
            let transferNumber = Float(number) / representation
            let roundNumber = roundf(transferNumber * 10) / 10
            
            let decimal = Int((roundNumber * 10)) % 10
            if decimal == 0 {
                string = "\(Int(roundNumber))" + postfix
                
            } else {
                string = String(format: "%.1f", roundNumber) + postfix
            }
        }
        
        return string
    }
    
    /**
     获取单行文本尺寸方法
     */
    func singleTextSize(font: UIFont) -> CGSize {
        
        let dict = [NSFontAttributeName: font]
        let textSize = (self as NSString).size(attributes: dict)
        
        return textSize
    }
    
    /**
     获取多行文本尺寸方法
     */
    func multiTextSize(font: UIFont, maxSize: CGSize) -> CGSize {
        
        let dict = [NSFontAttributeName: font];
        let textSize = (self as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: dict, context: nil).size
        
        return textSize
    }
    
    /**
     获取Unicode长度方法
     */
    func unicodeLength() -> Int {
        
        var asciiLength = 0
        for index in 0..<(self as NSString).length {
            let uniChar = (self as NSString).character(at: index)
            asciiLength += (isascii(Int32(uniChar)) == 1) ? 1 : 2
        }
        
        var unicodeLength = asciiLength / 2
        if (asciiLength % 2) == 1 {
            unicodeLength += 1
        }
        
        return unicodeLength
    }
    
    /**
     获取当前日期字符串方法
     */
    func nowDateString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let nowDate = Date()
        let dateString = formatter.string(from: nowDate)
        
        return dateString
    }
    
    /**
     获取UUID字符串方法
     */
    func uuidString() -> String {
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let uuidString = uuid?.replacingOccurrences(of: "-", with: "")
        
        return uuidString!
    }
    
    
    /**
     判断字符串有效方法
     */
    func checkString() -> Bool {
        
        if self != nil && self.characters.count > 0 {
            return true;
            
        } else {
            return false;
        }
    }

}

extension UIBarButtonItem {
    
    /**
     图片和目标和选择器便利初始化方法
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
}

extension UIButton {

    /**
     图片和背景图片便利初始化方法
     */
    convenience init(imageName: String?, backgroundImageName: String?) {

        self.init()

        if let name = imageName {
            setImage(UIImage(named: name), for: .normal)
            setImage(UIImage(named: name + "_highlighted"), for: .highlighted)
        }

        if let backgroundName = backgroundImageName {
            setBackgroundImage(UIImage(named: backgroundName), for: .normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), for: .highlighted)
        }

        sizeToFit()
    }

}

extension UIColor {

    /**
     十六进制颜色方法
     */
    static func color(hex: String) -> UIColor {
        
        return UIColor.color(hex: hex, alpha: 1.0)
    }
    
    /**
     十六进制透明度和颜色方法
     */
    static func color(hex: String, alpha: CGFloat) -> UIColor {
        
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if colorString.characters.count < 6 {
            return UIColor.clear
        }
        
        if colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
            
        } else if colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        
        if colorString.characters.count != 6 {
            return UIColor.clear
        }
        
        var range = NSRange(location: 0, length: 2)
        let redString = (colorString as NSString).substring(with: range)
        range.location = 2
        let greenString = (colorString as NSString).substring(with: range)
        range.location = 4
        let blueString = (colorString as NSString).substring(with: range)
        
        var scanner = Scanner(string: redString)
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0
        
        scanner.scanHexInt32(&red)
        scanner = Scanner(string: greenString)
        scanner.scanHexInt32(&green)
        scanner = Scanner(string: blueString)
        scanner.scanHexInt32(&blue)
        
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        return color
    }

}

extension UIImage {

    /**
     图片染色方法
     */
    func tintImage(color: UIColor, alpha: CGFloat) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
        let context = UIGraphicsGetCurrentContext()
        draw(in: rect)

        context?.setFillColor(color.cgColor)
        context?.setAlpha(alpha)
        context?.setBlendMode(.sourceAtop)
        context?.fill(rect)

        let imageRef = context?.makeImage()!
        let newImage = UIImage(cgImage: imageRef!, scale: scale, orientation: imageOrientation)
        UIGraphicsEndImageContext()

        return newImage
    }

    /**
     重叠图片方法
     */
    func overlapImage(color: UIColor) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContext(size)
        colorImage?.draw(in: rect)
        draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    /**
     比例切割图片方法
     */
    func resizableImage(name: String, scale: CGFloat) -> UIImage {
        
        let image = UIImage(named: name)!
        let width = image.size.width
        let height = image.size.height
        
        let newImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: height, left: width, bottom: height, right: width))
        return newImage
    }
    
    /**
     图片水印添加方法
     */
    func watermark(name: String, watermark: String, scale: CGFloat) -> UIImage {
     
        let backgroundImage = UIImage(named: name)!
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0)
        backgroundImage.draw(in: CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
        
        let watermarkImage = UIImage(named: watermark)!
        let margin: CGFloat = 5
        let watermarkWidth = watermarkImage.size.width * scale
        let watermarkHeight = watermarkImage.size.height * scale
        let watermarkX = watermarkImage.size.width - watermarkWidth - margin
        let watermarkY = watermarkImage.size.height - watermarkHeight - margin
        watermarkImage.draw(in: CGRect(x: watermarkX, y: watermarkY, width: watermarkWidth, height: watermarkHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    /**
     圆形裁剪图片方法
     */
    func clipCircle(name: String, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        
        let originImage = UIImage(named: name)!
        let originWidth = originImage.size.width + borderWidth * 2
        let originHeight = originImage.size.height + borderWidth * 2
        UIGraphicsBeginImageContextWithOptions(CGSize(width: originWidth, height: originHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        borderColor.set()
        
        let bigRadius = originWidth * 0.5
        let centerX = bigRadius
        let centerY = bigRadius
        context?.addArc(center: CGPoint(x: centerX, y: centerY), radius: bigRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        context?.fillPath()
        
        let smallRadius = bigRadius - borderWidth
        context?.addArc(center: CGPoint(x: centerX, y: centerY), radius: smallRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        context?.clip()
        originImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: originImage.size.width, height: originImage.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
     全屏截图方法
     */
    func capture(view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
     设置条纹背景方法
     */
    func stripeBackground(view: UIView, rowHeight: CGFloat, rowColor: UIColor, lineWidth: CGFloat, lineColor: UIColor) -> UIImage {
        
        let rowWidth = view.frame.size.width
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rowWidth, height: rowHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        rowColor.set()
        
        context?.addRect(CGRect(x: 0, y: 0, width: rowWidth, height: rowHeight))
        context?.fillPath()
        lineColor.set()
        context?.setLineWidth(lineWidth)
        
        let dividerX: CGFloat = 0
        let dividerY = rowHeight - lineWidth
        context?.move(to: CGPoint(x: dividerX, y: dividerY))
        context?.addLine(to: CGPoint(x: rowWidth - dividerX, y: dividerY))
        context?.strokePath()
        
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
        font = UIFont.systemFont(ofSize: fontSize)
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
            replace(range, withText: emojiString)
            
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
            attributedString.replaceCharacters(in: range, with: imageAttributedString)
            attributedText = attributedString
            
            selectedRange = NSRange(location: range.location + 1, length: 0)
            font = UIFont.systemFont(ofSize: 18)
            
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
        
        attributedText.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                string += attachment.emoticonChs!
                
            } else {
                string += (self.text as NSString).substring(with: range)
            }
        }
        
        return string
    }
    
}

extension UIView {
    
    /**
     获取缓存大小方法
     */
    func cachesSize() -> Float {
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        let fileAttributes = FileManager.default.subpaths(atPath: cachePath)!
        var size = 0
        
        for fileName in fileAttributes {
            let path = cachePath + "/\(fileName)"
            let attributes = try! FileManager.default.attributesOfItem(atPath: path)
            for (numberA, numberB) in attributes {
                if numberA == FileAttributeKey.size {
                    size += numberB as! Int
                }
            }
        }
        
        let cacheSize: Float = Float(size) / 1024 / 1024
        return cacheSize
    }
    
    /**
     清除缓存方法
     */
    func clearCaches() {
        
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        let fileAttributes = FileManager.default.subpaths(atPath: cachePath)!
        for fileName in fileAttributes {
            let path = cachePath + "/\(fileName)"
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    
                } catch {
                    print("清除缓存失败")
                }
            }
        }
    }
    
    /**
     绘制图片视图方法
     */
    func snapshot() -> UIImageView {
        
        let size = CGSize(width: frame.size.width, height: frame.size.height - 1);
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let newImageView = UIImageView(image: image)
        newImageView.layer.masksToBounds = false
        newImageView.layer.cornerRadius = 0
        newImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        newImageView.layer.shadowRadius = 5.0
        newImageView.layer.shadowOpacity = 0.4
        
        return newImageView
    }
    
    /**
     添加渐变色背景方法
     */
    func gradient(colorArray: [Any], start: CGPoint, end: CGPoint) {
        
        let layer = CAGradientLayer()
        layer.colors = colorArray
        layer.startPoint = start
        layer.endPoint = end
        layer.frame = self.bounds
        
        self.layer.addSublayer(layer)
    }
    
    /**
     添加弹性动画方法
     */
    func springAnimation(start: Float, end: Float) {
        
        let spring = CASpringAnimation(keyPath: "position.x")
        spring.stiffness = 100
        spring.damping = 10
        spring.mass = 1
        spring.initialVelocity = 0
        spring.fromValue = start
        spring.toValue = end
        spring.duration = spring.settlingDuration
        
        self.layer.add(spring, forKey: spring.keyPath)
    }

}

extension UIWindow {

    /**
     判断是否浅色方法
     */
    static func isLightColor(string: String) -> Bool {

        let redString = (string as NSString).substring(with: NSRange(location: 1, length: 2))
        let greenString = (string as NSString).substring(with: NSRange(location: 3, length: 2))
        let blueString = (string as NSString).substring(with: NSRange(location: 5, length: 2))

        var scanner = Scanner(string: redString)
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0
        
        scanner.scanHexInt32(&red)
        scanner = Scanner(string: greenString)
        scanner.scanHexInt32(&green)
        scanner = Scanner(string: blueString)
        scanner.scanHexInt32(&blue)

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
    static func showMessage(text: String, delay: TimeInterval) {
        
        let mainWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!
        let hud = MBProgressHUD.showAdded(to: mainWindow, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.hide(animated: true, afterDelay: delay)
    }
}
