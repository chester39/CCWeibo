//
//  CommentModel.swift
//		CCWeiboAPP
//		Chen Chen @ October 14th, 2016
//

import UIKit

class CommentModel: NSObject {
    
    /// 评论创建时间
    var createdAt: String?
    /// 评论ID
    var commentID: Int = 0
    /// 评论楼层
    var floorNumber: Int = 0
    /// 评论信息内容
    var text: String?
    /// 评论来源
    var source: String?
    /// 评论用户
    var user: UserModel?
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    /**
     默认KVC方法
     */
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == kUser {
            user = UserModel(dict: value as! [String: AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    /**
     存在未定义值KVC方法
     */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        switch key {
        case kWeiboID:
            commentID = value as! Int
            
        case kCreatedAt:
            createdAt = value as? String
            
        case kFloorNumber:
            floorNumber = value as! Int
            
        default:
            break
        }
    }
    
}
