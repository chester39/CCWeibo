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
    // 微博配图URL数组
    var thumbnailPictureArray: [NSURL]?
    // 转发微博用户昵称
    var retweetScreenNameText: String?
    // 转发微博用户认证图片
    var retweetVerifiedImage: UIImage?
    // 转发微博用户会员等级图片
    var retweetMemberRankImage: UIImage?
    // 转发微博创建时间
    var retweetCreatTimeText: String = ""
    // 转发微博来源
    var retweetSourceText: String = ""
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
            sourceText = "来自" + restString
        }
        
        if let pictureArray = (status.retweetedStatus != nil) ? status.retweetedStatus?.pictureURLArray : status.pictureURLArray {
            thumbnailPictureArray = [NSURL]()
            for dict in pictureArray {
                guard let urlString = dict[kThumbnailPicture] as? String else {
                    continue
                }
                
                let url = NSURL(string: urlString)!
                thumbnailPictureArray?.append(url)
            }
        }
        
        if status.retweetedStatus?.text != "" {
            if let name = status.retweetedStatus?.user?.screenName {
                retweetScreenNameText = "@" + name
            }
            
            switch status.retweetedStatus?.user?.verifiedType ?? -1 {
            case 0:
                retweetVerifiedImage = UIImage(named: "avatar_vip")
                
            case 2, 3, 5:
                retweetVerifiedImage = UIImage(named:"avatar_enterprise_vip")
                
            case 220:
                retweetVerifiedImage = UIImage(named:"avatar_grassroot")
                
            default:
                retweetVerifiedImage = nil
            }
            
            if status.retweetedStatus?.user?.memberRank >= 1 && status.retweetedStatus?.user?.memberRank <= 6 {
                retweetMemberRankImage = UIImage(named: "common_icon_membership_level\(status.retweetedStatus!.user!.memberRank)")
            }
            
            if let timeString = status.retweetedStatus?.createdAt where timeString != "" {
                let date = NSDate.convertStringToDate(timeString, formatterString: "EE MM dd HH:mm:ss Z yyyy")
                retweetCreatTimeText = NSDate.formatDateToString(date)
            }
            
            if let sourceString: NSString = status.retweetedStatus?.source where sourceString != "" {
                let startIndex = sourceString.rangeOfString(">").location + 1
                let length = sourceString.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
                let restString = sourceString.substringWithRange(NSMakeRange(startIndex, length))
                retweetSourceText = "来自" + restString
            }
        }
    }
}
