//
//	iOS培训
//		小码哥
//		Chen Chen @ August 23rd, 2016
//

import UIKit

class UserModel: NSObject {
    
    // 微博ID
    var weiboID: Int = 0
    // 用户昵称
    var screenName: String?
    // 用户头像地址
    var avatarLarge: String?
    // 用户认证类型
    var verifiedType: Int = -1
    // 用户会员等级
    var memberRank: Int = -1
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: AnyObject]) {
        
        super.init()
        
        weiboID = dict[kWeiboID] as! Int
        screenName = dict[kScreenName] as? String
        avatarLarge = dict[kAvatarLarge] as? String
        verifiedType = dict[kVerifiedType] as! Int
        memberRank = dict[kMbRank] as! Int
    }
    
    /**
     输出字符串描述
     */
    override var description: String {
        
        let property = [kWeiboID, kScreenName, kAvatarLarge, kVerifiedType]
        let dict = dictionaryWithValuesForKeys(property)
        
        return "\(dict)"
    }

}
