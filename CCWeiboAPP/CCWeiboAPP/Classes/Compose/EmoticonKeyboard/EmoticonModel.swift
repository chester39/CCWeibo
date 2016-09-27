//
//  EmoticonModel.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonModel: NSObject {
    
    /// 表情组名
    var id: String?
    /// 表情字符串
    var chs: String?
    /// 表情图片路径
    var pngPath: String?
    /// 转换后Emoji表情字符串
    var emojiString: String?
    /// 删除按钮与否
    var isRemoveButton: Bool = false
    /// 表情使用次数
    var count: Int = 0
    
    /// 表情图片
    var png: String? {
        didSet {
            let path = NSBundle.mainBundle().pathForResource(id, ofType: nil, inDirectory: "Emoticons.bundle")!
            pngPath = (path as NSString).stringByAppendingPathComponent(png ?? "")
        }
    }
    
    /// Emoji表情字符串
    var code: String? {
        didSet {
            let scanner = NSScanner(string: code ?? "")
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            emojiString = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     表情组名初始化方法
     */
    init(dict: [String: AnyObject], id: String) {
        
        self.id = id
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    /**
     删除按钮初始化方法
     */
    init(removeButton: Bool) {
        
        self.isRemoveButton = removeButton
        
        super.init()
    }
    
    /**
     存在未定义值KVC方法
     */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
