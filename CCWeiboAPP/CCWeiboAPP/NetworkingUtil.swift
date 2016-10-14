//
//	NetworkingUtil.swift
//		CCWeiboAPP
//		Chen Chen @ August 31st, 2016
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class NetworkingUtil {
    
    /// 单例初始化方法
    static let sharedInstance = NetworkingUtil()
    
    /**
     私有初始化方法
     */
    private init() {
        
    }
    
    // MARK: - 令牌方法
    
    /**
     获取请求令牌方法
     */
    func loadRequestToken(webView: WKWebView) {
        
        let path = "oauth2/authorize"
        let parameters = ["client_id": kWeiboAppKey, "redirect_uri": kWeiboRedirectUri]
        Alamofire.request(.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let request = response.request else {
                return
            }
            
            webView.loadRequest(request)
        }
    }
    
    /**
     获取使用令牌方法
     */
    func loadAccessToken(codeString: String?) {
        
        guard let code = codeString else {
            return
        }
        
        let path = "oauth2/access_token"
        let parameters = ["client_id": kWeiboAppKey, "client_secret": kWeiboAppSecret, "grant_type": "authorization_code", "code": code, "redirect_uri": kWeiboRedirectUri]
        Alamofire.request(.POST, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                return
            }
            
            let json = JSON(data: data)
            guard let dict = json.dictionaryObject else {
                return
            }
            
            let account = UserAccount(dict: dict)
            account.loadUserInfo({ (account, error) in
                account?.saveUserAccount()
            })
        }
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博内容方法
     */
    func loadWeiboStatuses(sinceID: Int, maxID: Int, finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let path = "2/statuses/home_timeline.json"
        let temp = (maxID != 0) ? maxID - 1 : maxID
        let parameters = [kAccessToken: UserAccount.loadUserAccount()!.accessToken!, "since_id": String(sinceID), "max_id": String(temp)]
        Alamofire.request(.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            var array = [[String: AnyObject]]()
            for (index: _, subJson: subJSON) in json["statuses"] {
                guard let dict = subJSON.dictionaryObject else {
                    finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                    return
                }
                
                array.append(dict)
            }
            
            finished(array: array, error: nil)
        }
    }
    
    /**
     读取公共微博方法
     */
    func loadPublicStatuses(finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let path = "2/statuses/public_timeline.json"
        let parameters = [kAccessToken: UserAccount.loadUserAccount()!.accessToken!]
        Alamofire.request(.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            var array = [[String: AnyObject]]()
            for (index: _, subJson: subJSON) in json["statuses"] {
                guard let dict = subJSON.dictionaryObject else {
                    finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                    return
                }
                
                array.append(dict)
            }
            
            finished(array: array, error: nil)
        }
    }
    
    /**
     发送微博内容方法
     */
    func sendWeiboStatuses(status: String, image: UIImage?, finished: (object: AnyObject?, error: NSError?) -> ()) {
        
        var path = "2/statuses/"
        let parameters = [kAccessToken: UserAccount.loadUserAccount()!.accessToken!, "status": status]
        if image == nil {
            path += "update.json"
            Alamofire.request(.POST, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
                guard let data = response.data else {
                    finished(object: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "发送微博失败"]))
                    return
                }
                
                let json = JSON(data: data)
                let dict = json.dictionaryObject
                finished(object: dict, error: nil)
            }
            
        } else {
            path += "upload.json"
            Alamofire.upload(.POST, kWeiboBaseURL + path, multipartFormData: { (multipartFormData) in
                let imageData = UIImagePNGRepresentation(image!)!
                let imageName = String(NSDate()) + ".png"
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                
                multipartFormData.appendBodyPart(data: imageData, name: "pic", fileName: imageName, mimeType: "image/png")
                }, encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { response in
                            let json = JSON(data: response.data!)
                            let dict = json.dictionaryObject
                            finished(object: dict, error: nil)
                        })
                        
                    case .Failure(_):
                        finished(object: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "发送微博失败"]))
                    }
            })
        }
    }
    
    /**
     搜索用户方法
     */
    func searchWeiboUsers(search: String?, finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        let path = "2/search/suggestions/users.json"
        let parameters = [kAccessToken: UserAccount.loadUserAccount()!.accessToken!, "q": search ?? "", "count": String(50)]
        Alamofire.request(.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "搜索数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            var array = [[String: AnyObject]]()
            guard let jsonArray = json.arrayObject else {
                finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "搜索数据失败"]))
                return
            }
            
            for dict in jsonArray {
                array.append(dict as! [String : AnyObject])
            }
            
            finished(array: array, error: nil)
        }
    }
    
    /**
     读取微博评论方法
     */
    func loadStatusCommits(id: Int, finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let path = "2/comments/show.json"
        let parameters = [kAccessToken: UserAccount.loadUserAccount()!.accessToken!, kWeiboID: String(id)]
        Alamofire.request(.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let data = response.data else {
                finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            let json = JSON(data: data)
            var array = [[String: AnyObject]]()
            for (index: _, subJson: subJSON) in json["comments"] {
                guard let dict = subJSON.dictionaryObject else {
                    finished(array: nil, error: NSError(domain: "com.github.chester39", code: 1000, userInfo: ["message": "获取数据失败"]))
                    return
                }
                
                array.append(dict)
            }
            
            finished(array: array, error: nil)
        }
    }
    
}