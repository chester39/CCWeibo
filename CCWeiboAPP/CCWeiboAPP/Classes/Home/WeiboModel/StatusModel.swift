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
        
        if key == kCreatedAt {
            createdAt = value as? String
        }
    }
    
}
