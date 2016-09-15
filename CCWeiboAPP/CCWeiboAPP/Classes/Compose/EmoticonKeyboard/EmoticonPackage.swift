//
//  EmoticonPackage.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

class EmoticonPackage: NSObject {

    /// 表情包id
    var id: String?
    /// 表情包名称
    var groupNameCn:String?
    /// 表情包全部表情
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
    class func loadEmoticonPackageArray() -> [EmoticonPackage] {
        
        var modelArray = [EmoticonPackage]()
        
        let package = EmoticonPackage(id: "")
        package.appendEmptyEmoticon()
        modelArray.append(package)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String: AnyObject]]
        for packageDict in array {
            let package = EmoticonPackage(id: packageDict["id"] as! String)
            package.loadEmoticonArray()
            package.appendEmptyEmoticon()
            modelArray.append(package)
        }
        
        return modelArray
    }
    
    /**
     读取表情组数据方法
     */
    private func loadEmoticonArray() {
        
        let path = NSBundle.mainBundle().pathForResource(self.id, ofType: nil, inDirectory: "Emoticons.bundle")!
        let filePath = (path as NSString).stringByAppendingPathComponent("info.plist")
        let dict = NSDictionary(contentsOfFile: filePath)!
        
        groupNameCn = dict["group_name_cn"] as? String
        let array = dict["emoticons"] as! [[String: AnyObject]]
        var modelArray = [EmoticonModel]()
        var index = 0
        for emoticonDict in array {
            if index == 20 {
                let emoticon = EmoticonModel(removeButton: true)
                modelArray.append(emoticon)
                index = 0
                continue
            }
            
            let emoticon = EmoticonModel(dict: emoticonDict, id: self.id!)
            modelArray.append(emoticon)
            index += 1
        }
        
        emoticonArray = modelArray
    }
    
    /**
     添加空表情方法
     */
    private func appendEmptyEmoticon() {
        
        if emoticonArray == nil {
            emoticonArray = [EmoticonModel]()
        }
        
        let number = emoticonArray!.count % 21
        for _ in number ..< 20 {
            let emoticon = EmoticonModel(removeButton: false)
            emoticonArray?.append(emoticon)
        }
        
        let emoticon = EmoticonModel(removeButton: true)
        emoticonArray?.append(emoticon)
    }
    
    /**
     添加最近表情方法
     */
    func appendLastEmoticon(emoticon: EmoticonModel) {
        
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
    
}