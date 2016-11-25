//
//  UserAccount.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 18th, 2016
//

import UIKit

import Alamofire
import SwiftyJSON

class UserAccount: NSObject, NSCoding {

    /// 授权使用令牌
    var accessToken: String?
    /// 授权用户ID
    var uid: String?
    /// 授权过期具体时间
    var expiresDate: Date?
    /// 用户昵称
    var screenName: String?
    /// 用户头像地址
    var avatarLarge: String?
    /// 用户授权模型
    static var userAccount: UserAccount?
    /// 归档文件路径
    static let filePath: String = kUserAccountFileName.acquireDocumentDirectory()
    /// 用户简介
    var descriptionIntro: String?
    /// 用户粉丝数
    var followersCount: Int = 0
    /// 用户关注数
    var friendsCount: Int = 0
    /// 用户微博数
    var statusesCount: Int = 0
    
    /// 授权生命周期
    var expiresIn: Int = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }

    /**
     存在未定义值KVC方法
     */
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        switch key {
        case kAccessToken:
            accessToken = value as? String
            
        case kExpiresIn:
            expiresIn = value as! Int
            
        case kExpiresDate:
            expiresDate = value as? Date
            
        case kDescription:
            descriptionIntro = value as? String
            
        case kFollowersCount:
            followersCount = value as! Int
            
        case kFriendsCount:
            friendsCount = value as! Int
            
        case kStatusesCount:
            statusesCount = value as! Int
            
        default:
            break
        }
    }

    // MARK: - NSCoding协议方法
    
    /**
     数据编码方法
     */
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(accessToken, forKey: kAccessToken)
        aCoder.encode(expiresIn, forKey: kExpiresIn)
        aCoder.encode(uid, forKey: kUID)
        aCoder.encode(expiresDate, forKey: kExpiresDate)
        aCoder.encode(avatarLarge, forKey: kAvatarLarge)
        aCoder.encode(screenName, forKey: kScreenName)
        aCoder.encode(descriptionIntro, forKey: kDescription)
        aCoder.encode(followersCount, forKey: kFollowersCount)
        aCoder.encode(friendsCount, forKey: kFriendsCount)
        aCoder.encode(statusesCount, forKey: kStatusesCount)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        accessToken = aDecoder.decodeObject(forKey: kAccessToken) as? String
        expiresIn = aDecoder.decodeInteger(forKey: kExpiresIn)
        uid = aDecoder.decodeObject(forKey: kUID) as? String
        expiresDate = aDecoder.decodeObject(forKey: kExpiresDate) as? Date
        avatarLarge = aDecoder.decodeObject(forKey: kAvatarLarge) as? String
        screenName = aDecoder.decodeObject(forKey: kScreenName) as? String
        descriptionIntro = aDecoder.decodeObject(forKey: kDescription) as? String
        followersCount = aDecoder.decodeInteger(forKey: kFollowersCount)
        friendsCount = aDecoder.decodeInteger(forKey: kFriendsCount)
        statusesCount = aDecoder.decodeInteger(forKey: kStatusesCount)
    }
    
    // MARK: - 归档方法
    
    /**
     保存用户账户模型方法
     */
    func saveUserAccount() -> Bool {
        
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /**
     读取用户账户模型方法
     */
    class func loadUserAccount() -> UserAccount? {
        
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else {
            return nil
        }
        
        if UserAccount.userAccount != nil {
            return UserAccount.userAccount
        }
        print(UserAccount.filePath)
        
        guard let date = account.expiresDate, date.compare(Date()) != .orderedAscending else {
            print("授权已过期")
            return nil
        }
        
        UserAccount.userAccount = account
        
        return UserAccount.userAccount
    }
    
    // MARK: - 用户方法
    
    /**
     用户是否登录方法
     */
    class func isUserLogin() -> Bool {
        
        return UserAccount.loadUserAccount() != nil
    }
    
    /**
     读取用户信息方法
     */
    func loadUserInfo(finished: @escaping (_ account: UserAccount?, _ error: NSError?) -> ()) {
        
        assert(accessToken != nil, "使用该方法必须首先进行授权")
        
        let path = "2/users/show.json"
        let parameters = ["access_token": accessToken!, "uid": uid!]
        Alamofire.request(kWeiboBaseURL + path, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(nil, NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            self.avatarLarge = json[kAvatarLarge].string
            self.screenName = json[kScreenName].string
            self.descriptionIntro = json[kDescription].string
            self.followersCount = json[kFollowersCount].int!
            self.friendsCount = json[kFriendsCount].int!
            self.statusesCount = json[kStatusesCount].int!
            
            finished(self, nil)
        }
    }
    
}
