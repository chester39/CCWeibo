//
//  StatusViewModel.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

class StatusViewModel: NSObject {

    /// 用户头像URL
    var iconImageURL: URL?
    /// 用户认证图片
    var verifiedImage: UIImage?
    /// 用户会员等级图片
    var memberRankImage: UIImage?
    /// 微博创建时间
    var creatTimeText: String = ""
    /// 微博来源
    var sourceText: String = ""
    /// 微博配图URL数组
    var thumbnailPictureArray: [URL]?
    /// 微博配图大图URL数组
    var middlePictureArray: [URL]?
    /// 转发微博信息内容
    var retweetText: String?
    /// 微博模型
    var status: StatusModel
    
    /**
     自定义初始化方法
     */
    init(status: StatusModel) {
        
        self.status = status
        
        iconImageURL = URL(string: status.user?.avatarLarge ?? "")
        
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
        
        if status.user!.memberRank >= 1 && status.user!.memberRank <= 6 {
            memberRankImage = UIImage(named: "common_icon_membership_level\(status.user!.memberRank)")
        }
        
        if let timeString = status.createdAt, timeString != "" {
            let date = Date.convertStringToDate(timeString: timeString, formatterString: "EE MM dd HH:mm:ss Z yyyy")
            creatTimeText = Date.formatDateToString(date: date)
        }
        
        if let sourceString: NSString = status.source as NSString?, sourceString != "" {
            let startIndex = sourceString.range(of: ">").location + 1
            let length = sourceString.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            let restString = sourceString.substring(with: NSMakeRange(startIndex, length))
            sourceText = "来自" + restString
        }
        
        if let pictureArray = (status.retweetedStatus != nil) ? status.retweetedStatus?.pictureURLArray : status.pictureURLArray {
            thumbnailPictureArray = [URL]()
            middlePictureArray = [URL]()
            for dict in pictureArray {
                guard var urlString = dict[kThumbnailPicture] as? String else {
                    continue
                }
                
                var url = URL(string: urlString)!
                thumbnailPictureArray?.append(url)
                
                urlString = urlString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
                url = URL(string: urlString)!
                middlePictureArray?.append(url)
            }
        }
        
        if let text = status.retweetedStatus?.text {
            let name = status.retweetedStatus?.user?.screenName ?? ""
            retweetText = "@" + name + ":" + text
        }
        
    }

}
