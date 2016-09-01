//
//	iOS培训
//		小码哥
//		Chen Chen @ August 23rd, 2016
//

import UIKit

class StatusModel: NSObject {

    // 微博创建时间
    var createdAt: String?
    // 微博ID
    var weiboID: Int = 0
    // 微博信息内容
    var text: String?
    // 微博来源
    var source: String?
    // 微博配图数组
    var pictureURLArray: [[String: AnyObject]]?
    // 转发数
    var repostsCount: Int = 0
    // 评论数
    var commentsCount: Int = 0
    // 表态数
    var attitudesCount: Int = 0
    // 转发微博
    var retweetedStatus: StatusModel?
    // 微博用户
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
     输出字符串描述
     */
    override var description: String {
        
        let property = [kCreatedAt, kWeiboID, kWeiboText, kWeiboSource]
        let dict = dictionaryWithValuesForKeys(property)
        
        return "\(dict)"
    }
    
    /**
     默认KVC方法
     */
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "user" {
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
            weiboID = value as! Int
            
        case kCreatedAt:
            createdAt = value as? String
            
        case kPictureURLArray:
            pictureURLArray = value as? [[String: AnyObject]]
            
        case kRepostsCount:
            repostsCount = value as! Int
            
        case kCommentsCount:
            commentsCount = value as! Int
            
        case kAttitudesCount:
            attitudesCount = value as! Int
            
        case kRetweetedStatus:
            retweetedStatus = StatusModel(dict: value as! [String: AnyObject])
            
        default:
            break
        }
    }
    
}
