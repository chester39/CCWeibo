//
//  EmoticonManager.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonManager: NSObject {
    
    /// 表情包id
    var id: String?
    /// 表情包名称
    var groupNameCn: String?
    /// 表情包全部表情
    var emoticonArray: [EmoticonModel]?
    /// 最大每页表情数
    let maxEmoticonCount = 21
    
    // MARK: - 初始化方法
    
    /**
     id初始化方法
     */
    init(id: String) {
        
        self.id = id
        
        super.init()
    }
    
    // MARK: - 数据方法
    
    /**
     读取表情包数据方法
     */
    class func loadEmoticonManagerArray() -> [EmoticonManager] {
        
        var modelArray = [EmoticonManager]()
        
        let recentManager = EmoticonManager(id: "")
        recentManager.groupNameCn = "最近"
        recentManager.appendEmptyEmoticon()
        modelArray.append(recentManager)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String: AnyObject]]
        for managerDict in array {
            let manager = EmoticonManager(id: managerDict["id"] as! String)
            manager.loadEmoticon()
            manager.appendEmptyEmoticon()
            modelArray.append(manager)
        }
        
        return modelArray
    }
    
    /**
     读取表情组数据方法
     */
    private func loadEmoticon() {
        
        let path = NSBundle.mainBundle().pathForResource(self.id, ofType: nil, inDirectory: "Emoticons.bundle")!
        let filePath = (path as NSString).stringByAppendingPathComponent("info.plist")
        let dict = NSDictionary(contentsOfFile: filePath)!
        
        groupNameCn = dict["group_name_cn"] as? String
        let array = dict["emoticons"] as! [[String: AnyObject]]
        var modelArray = [EmoticonModel]()
        var index = 0
        for emoticonDict in array {
            if index == maxEmoticonCount - 1 {
                let emoticon = EmoticonModel(removeButton: true)
                modelArray.append(emoticon)
                index = 0
            }
            
            let emoticon = EmoticonModel(dict: emoticonDict, id: id!)
            modelArray.append(emoticon)
            index += 1
        }
        
        emoticonArray = modelArray
    }
    
    // MARK: - 完善表情方法
    
    /**
     添加空表情方法
     */
    private func appendEmptyEmoticon() {
        
        if emoticonArray == nil {
            emoticonArray = [EmoticonModel]()
        }
        
        let number = emoticonArray!.count % maxEmoticonCount
        for _ in number ..< maxEmoticonCount - 1 {
            let emoticon = EmoticonModel(removeButton: false)
            emoticonArray?.append(emoticon)
        }
        
        let emoticon = EmoticonModel(removeButton: true)
        emoticonArray?.append(emoticon)
    }
    
    /**
     添加最近表情方法
     */
    func appendRecentEmoticon(emoticon: EmoticonModel) {
        
        emoticonArray?.removeLast()
        
        if emoticonArray!.contains(emoticon) == false {
            emoticonArray?.removeLast()
            emoticonArray?.append(emoticon)
        }
        
        let array = emoticonArray?.sort({ (a, b) -> Bool in
            return a.count > b.count
        })
        
        emoticonArray = array
        emoticonArray?.append(EmoticonModel(removeButton: true))
    }
    
    // MARK: - 复合字符串方法
    
    /**
     创建表情复合字符串方法
     */
    class func emoticonMutableAttributedString(string: String, font: UIFont) -> NSMutableAttributedString {
        
        let pattern = "\\[.*?\\]"
        let regularExpression = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        let resultArray = regularExpression.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.characters.count))
        let attributedString = NSMutableAttributedString(string: string)
        for result in resultArray.reverse() {
            let chs = (string as NSString).substringWithRange(result.range)
            let pngPath = findPngPath(chs)
            guard let tempPngPath = pngPath else {
                continue
            }
            
            let attachment = NSTextAttachment()
            let fontHeight = font.lineHeight
            attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
            attachment.image = UIImage(contentsOfFile: tempPngPath)
            let emoticonAttributedString = NSAttributedString(attachment: attachment)
            
            attributedString.replaceCharactersInRange(result.range, withAttributedString: emoticonAttributedString)
        }
        
        return attributedString
    }
    
    /**
     寻找图片文件方法
     */
    class func findPngPath(chs: String) -> String? {
        
        let managerArray = EmoticonManager.loadEmoticonManagerArray()
        for manager in managerArray {
            guard let emoticonArray = manager.emoticonArray else {
                print("空表情包")
                continue
            }
            
            var pngPath: String?
            for emoticon in emoticonArray {
                guard let emoticonChs = emoticon.chs else {
                    continue
                }
                
                if emoticonChs == chs {
                    pngPath = emoticon.pngPath
                    break
                }
            }
            
            if pngPath != nil {
                return pngPath
            }
        }
        
        return nil
    }
    
}
