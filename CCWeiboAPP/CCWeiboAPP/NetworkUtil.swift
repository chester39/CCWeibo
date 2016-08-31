//
//	iOS培训
//		小码哥
//		Chen Chen @ August 31st, 2016
//

import UIKit
import WebKit

import Alamofire

class NetworkUtil {
    
    // 单例初始化方法
    static let sharedInstance = NetworkUtil()
    
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
        
        let urlString = "\(kWeiboBaseURL)oauth2/authorize?client_id=\(kWeiboAppKey)&redirect_uri=\(kWeiboRedirectUri)"
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
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
        Alamofire.request(Method.POST, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("\(json)")
            }
            
            let account = UserAccount(dict: response.result.value as! [String: AnyObject])
            account.loadUserInfo({ (account) in
                account?.saveUserAccount()
            })
        }
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博内容方法
     */
    func loadWeiboStatuses(finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let path = "2/statuses/home_timeline.json"
        let parameters = ["access_token": UserAccount.loadUserAccount()!.accessToken!]
        Alamofire.request(Method.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            print(response.result.value)
            guard let array = (response.result.value as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                finished(array: nil, error: NSError(domain: "com.github.chester", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            finished(array: array, error: nil)
        }
    }

}
