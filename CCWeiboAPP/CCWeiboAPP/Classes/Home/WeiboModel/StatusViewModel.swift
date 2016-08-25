//
//	iOS培训
//		小码哥
//		Chen Chen @ August 25th, 2016
//

import UIKit

class StatusViewModel: NSObject {
    
    // 用户头像URL
    var iconImageURL: NSURL?
    // 用户认证图片
    var verifiedImage: UIImage?
    // 用户会员等级图片
    var memberRankImage: UIImage?
    // 微博创建时间
    var creatTimeText: String = ""
    // 微博来源
    var sourceText: String = ""
    
    // 微博模型
    var status: StatusModel
    
    /**
     自定义初始化方法
     */
    init(status: StatusModel) {
        
        self.status = status
        
        iconImageURL = NSURL(string: status.user?.avatarLarge ?? "")
        
        switch status.user?.verifiedType ?? -1 {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named:"avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named:"avatar_grassroot")
        default:
            verifiedImage = nil
        }

        if status.user?.memberRank >= 1 && status.user?.memberRank <= 6 {
            memberRankImage = UIImage(named: "common_icon_membership_level\(status.user!.memberRank)")
        }
        
        if let timeString = status.createdAt where timeString != "" {
            let date = NSDate.convertStringToDate(timeString, formatterString: "EE MM dd HH:mm:ss Z yyyy")
            creatTimeText = NSDate.formatDateToString(date)
        }
        
        if let sourceString: NSString = status.source where sourceString != "" {
            let startIndex = sourceString.rangeOfString(">").location + 1
            let length = sourceString.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            let restString = sourceString.substringWithRange(NSMakeRange(startIndex, length))
            sourceText = "来自: " + restString
        }
    }

}
