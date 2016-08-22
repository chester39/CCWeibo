//
//	iOS培训
//		小码哥
//		Chen Chen @ August 18th, 2016
//

import UIKit
import WebKit

import Alamofire
import Cartography
import MBProgressHUD

class OAuthViewController: UIViewController {
    
    // 授权网页视图
    var oauthView = WKWebView(frame: kScreenFrame)
    // 透明指示层
    var hud = MBProgressHUD()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(19), NSForegroundColorAttributeName: UIColor.orangeColor()]
        navigationItem.title = "授权页面"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(fillButtonDidClick))
        
        oauthView.navigationDelegate = self
        view.addSubview(oauthView)
        
        loadRequestToken()
    }

    // MARK: - 令牌方法
    
    /**
     获取请求令牌方法
     */
    private func loadRequestToken() {

        let urlString = "\(kWeiboURL)oauth2/authorize?client_id=\(kWeiboAppKey)&redirect_uri=\(kWeiboRedirectUri)"
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        oauthView.loadRequest(request)
    }
    
    /**
     获取使用令牌方法
     */
    private func loadAccessToken(codeString: String?) {
        
        guard let code = codeString else {
            return
        }
        
        let path = "oauth2/access_token"
        let parameters = ["client_id": kWeiboAppKey, "client_secret": kWeiboAppSecret, "grant_type": "authorization_code", "code": code, "redirect_uri": kWeiboRedirectUri]
        Alamofire.request(Method.POST, kWeiboURL + path, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("\(json)")
            }
            
            let account = UserAccount(dict: response.result.value as! [String: AnyObject])
            account.loadUserInfo({ (account) in
                account?.saveUserAccount()
            })
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     填充按钮点击方法
     */
    func fillButtonDidClick() {
        
        let jsString = "document.getElementById('userId').value = 'c910309c@sina.com';"
        oauthView.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
}

extension OAuthViewController: WKNavigationDelegate {

    /**
     网页开始加载方法
     */
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在加载中......"
    }
    
    /**
     网页结束加载方法
     */
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        hud.hideAnimated(true)
    }
    
    /**
     收到响应后跳转与否方法
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        hud.hideAnimated(true)
        print(navigationAction.request)
        guard let urlString = navigationAction.request.URL?.absoluteString else {
            return
        }
        
        if urlString.hasPrefix(kWeiboRedirectUri) == false {
            decisionHandler(WKNavigationActionPolicy.Allow)
        }
        
        let key = "code="
        if urlString.containsString(key) {
            let code = navigationAction.request.URL?.query?.substringFromIndex(key.endIndex)
            loadAccessToken(code)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        
        decisionHandler(WKNavigationActionPolicy.Cancel)
    }
    
}
