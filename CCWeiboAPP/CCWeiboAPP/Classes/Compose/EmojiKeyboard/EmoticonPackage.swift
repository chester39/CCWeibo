//
//  EmoticonPackage.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonPackage: NSObject {

    // 表情包id
    var id: String?
    // 表情包名称
    var groupNameCn:String?
    // 表情包全部表情
    var emoticonArray: [EmoticonModel]?
    
    // MARK: - 初始化方法
    
    /**
     id初始化方法
     */
    init(id: String) {
        
        self.id = id
    }
    
    // MARK: - 数据方法
    
    /**
     读取表情包数据方法
     */
    class func loadEmoticonPackage() -> [EmoticonPackage] {
        
        var modelArray = [EmoticonPackage]()
        
        
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String: AnyObject]]
        for packageDict in array {
            let package = EmoticonPackage(id: packageDict["id"] as! String)
            modelArray.append(package)
        }
        
        return modelArray
    }
    
    /**
     读取表情组数据方法
     */
    private func loadEmoticonArray() {
        
    }
    
}