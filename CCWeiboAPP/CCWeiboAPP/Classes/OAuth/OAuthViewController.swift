//
//	iOS培训
//		小码哥
//		Chen Chen @ August 18th, 2016
//

import UIKit
import WebKit
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
        acquireRequestToken()
        
    }

    // MARK: - 界面方法
    
    /**
     获取请求令牌方法
     */
    private func acquireRequestToken() {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=2576232033&redirect_uri=https://github.com/chester39"
        guard let url = NSURL(string: urlString) else {
            return
        }
        let request = NSURLRequest(URL: url)
        oauthView.loadRequest(request)
    }
    
}

extension OAuthViewController: WKNavigationDelegate {

    /**
     收到响应后跳转与否方法
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        print(navigationAction.request)
        decisionHandler(WKNavigationActionPolicy.Cancel)

    }
}
