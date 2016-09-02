//
//	StatusViewModel.swift
//		CCWeiboAPP
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
    // 微博配图大图URL数组
    var middlePictureArray: [NSURL]?
    // 转发微博信息内容
    var retweetText: NSMutableAttributedString?
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
            middlePictureArray = [NSURL]()
            for dict in pictureArray {
                guard var urlString = dict[kThumbnailPicture] as? String else {
                    continue
                }
                
                var url = NSURL(string: urlString)!
                thumbnailPictureArray?.append(url)
                
                urlString = urlString.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                url = NSURL(string: urlString)!
                middlePictureArray?.append(url)
            }
        }
        
        if let text = status.retweetedStatus?.text {
            let name = status.retweetedStatus?.user?.screenName ?? ""
            let length = name.characters.count + 1
            retweetText = NSMutableAttributedString(string: "@" + name + ": " + text)
            retweetText?.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: 0x3F6380), range: NSMakeRange(0, length))
        }
    }
}
