//
//	UserAccount.swift
//		CCWeiboAPP
//		Chen Chen @ August 22nd, 2016
//

import UIKit

import Alamofire
import SwiftyJSON

class UserAccount: NSObject {
    
    /// 授权使用令牌
    var accessToken: String?
    /// 授权用户ID
    var uid: String?
    /// 授权过期具体时间
    var expiresDate: NSDate?
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
            expiresDate = NSDate(timeIntervalSinceNow: NSTimeInterval(expiresIn))
        }
    }
    
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
        
        let property = [kAccessToken, kExpiresIn, kUID, kExpiresDate]
        let dict = dictionaryWithValuesForKeys(property)
        
        return "\(dict)"
    }
    
    /**
     存在未定义值KVC方法
     */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        switch key {
        case kAccessToken:
            accessToken = value as? String
            
        case kExpiresIn:
            expiresIn = value as! Int
            
        case kExpiresDate:
            expiresDate = value as? NSDate
            
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
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(accessToken,forKey: kAccessToken)
        aCoder.encodeInteger(expiresIn, forKey: kExpiresIn)
        aCoder.encodeObject(uid, forKey: kUID)
        aCoder.encodeObject(expiresDate, forKey: kExpiresDate)
        aCoder.encodeObject(avatarLarge, forKey: kAvatarLarge)
        aCoder.encodeObject(screenName, forKey: kScreenName)
        aCoder.encodeObject(descriptionIntro, forKey: kDescription)
        aCoder.encodeInteger(followersCount, forKey: kFollowersCount)
        aCoder.encodeInteger(friendsCount, forKey: kFriendsCount)
        aCoder.encodeInteger(statusesCount, forKey: kStatusesCount)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        accessToken = aDecoder.decodeObjectForKey(kAccessToken) as? String
        expiresIn = aDecoder.decodeIntegerForKey(kExpiresIn) as Int
        uid = aDecoder.decodeObjectForKey(kUID) as? String
        expiresDate = aDecoder.decodeObjectForKey(kExpiresDate) as? NSDate
        avatarLarge = aDecoder.decodeObjectForKey(kAvatarLarge) as? String
        screenName = aDecoder.decodeObjectForKey(kScreenName) as? String
        descriptionIntro = aDecoder.decodeObjectForKey(kDescription) as? String
        followersCount = aDecoder.decodeIntegerForKey(kFollowersCount) as Int
        friendsCount = aDecoder.decodeIntegerForKey(kFriendsCount) as Int
        statusesCount = aDecoder.decodeIntegerForKey(kStatusesCount) as Int
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
        
        if UserAccount.userAccount != nil {
            return UserAccount.userAccount
        }
        
        print(UserAccount.filePath)
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount else {
            return UserAccount.userAccount
        }
        
        guard let date = account.expiresDate where date.compare(NSDate()) != NSComparisonResult.OrderedAscending else {
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
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?) -> ()) {
        
        assert(accessToken != nil, "使用该方法必须首先进行授权")
        
        let path = "2/users/show.json"
        let parameters = ["access_token": accessToken!, "uid": uid!]
        Alamofire.request(Method.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(account: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            self.avatarLarge = json[kAvatarLarge].string
            self.screenName = json[kScreenName].string
            self.descriptionIntro = json[kDescription].string
            self.followersCount = json[kFollowersCount].int!
            self.friendsCount = json[kFriendsCount].int!
            self.statusesCount = json[kStatusesCount].int!
            
            finished(account: self, error: nil)
        }
    }

}
