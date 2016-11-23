//
//  UserModel.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

class UserModel: NSObject {

    /// 用户ID
    var userID: Int = 0
    /// 用户昵称
    var screenName: String?
    /// 用户头像地址
    var avatarLarge: String?
    /// 用户认证类型
    var verifiedType: Int = -1
    /// 用户会员等级
    var memberRank: Int = -1
    /// 用户简介
    var descriptionIntro: String?
    /// 用户粉丝数
    var followersCount: Int = 0
    /// 用户关注数
    var friendsCount: Int = 0
    /// 用户微博数
    var statusesCount: Int = 0
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: Any]) {
        
        super.init()
        
        userID = dict[kWeiboID] as! Int
        screenName = dict[kScreenName] as? String
        avatarLarge = dict[kAvatarLarge] as? String
        verifiedType = dict[kVerifiedType] as! Int
        memberRank = dict[kMbRank] as! Int
        descriptionIntro = dict[kDescription] as? String
        followersCount = dict[kFollowersCount] as! Int
        friendsCount = dict[kFriendsCount] as! Int
        statusesCount = dict[kStatusesCount] as! Int
    }
    
}
