//
//  EmoticonModel.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 22nd, 2016
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
            let path = Bundle.main.path(forResource: id, ofType: nil, inDirectory: "Emoticons.bundle")!
            pngPath = (path as NSString).appendingPathComponent(png ?? "")
        }
    }
    
    /// Emoji表情字符串
    var code: String? {
        didSet {
            let scanner = Scanner(string: code ?? "")
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            emojiString = "\(Character(UnicodeScalar(result)!))"
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     表情组名初始化方法
     */
    init(dict: [String: Any], id: String) {
        
        self.id = id
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    /**
     删除按钮初始化方法
     */
    init(removeButton: Bool) {
        
        isRemoveButton = removeButton
        
        super.init()
    }
    
    /**
     存在未定义值KVC方法
     */
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        
    }
    
}
