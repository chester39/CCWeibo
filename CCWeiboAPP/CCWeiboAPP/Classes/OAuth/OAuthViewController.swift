//
//	iOS培训
//		小码哥
//		Chen Chen @ August 18th, 2016
//

import UIKit
import WebKit
import Alamofire
import Cartography

class OAuthViewController: UIViewController {
    
    var oauthView = WKWebView(frame: kScreenFrame)
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        oauthView.navigationDelegate = self
        view.addSubview(oauthView)
        loadRequestToken()
        
    }

    // MARK: - 令牌方法
    
    /**
     获取请求令牌方法
     */
    private func loadRequestToken() {
        
        let urlString = kWeiboURL + "oauth2/authorize?client_id=2576232033&redirect_uri=" + kTokenURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        oauthView.loadRequest(request)
    }
    
    private func loadAccessToken(codeString: String?) {
        
        guard let code = codeString else {
            return
        }
        
        let path = "oauth2/access_token"
        let parameters = ["client_id": "2576232033", "client_secret": "3839ebe10107d44f1d8064fbc397b696", "grant_type": "authorization_code", "code": code, "redirect_uri": kTokenURL]
        Alamofire.request(Method.POST, kWeiboURL + path, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("\(json)")
            }
        }
    }
    
}

extension OAuthViewController: WKNavigationDelegate {

    /**
     收到响应后跳转与否方法
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        print(navigationAction.request)
        guard let urlString = navigationAction.request.URL?.absoluteString else {
            return
        }
        
        if urlString.hasPrefix(kTokenURL) == false {
            print("不是授权回调页面")
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
        
        print("是授权回调页面")
        let key = "code="
        if urlString.containsString(key) {
            let code = navigationAction.request.URL?.query?.substringFromIndex(key.endIndex)
            print(code)
            loadAccessToken(code)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        
        print("授权失败")
        decisionHandler(WKNavigationActionPolicy.Cancel)
    }
    
}

/*
 
 {
 "access_token" = "2.00fgeIPBZdb2oCd3a1151c37_zYi6B";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 1139840901;
 }
 
 */