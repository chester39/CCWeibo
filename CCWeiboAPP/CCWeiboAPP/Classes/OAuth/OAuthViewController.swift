//
//	OAuthViewController.swift
//		CCWeiboAPP
//		Chen Chen @ August 18th, 2016
//

import UIKit
import WebKit

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
        
        NetworkingUtil.sharedInstance.loadRequestToken(oauthView)
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(kRootViewControllerSwitched, object: true)
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
            NetworkingUtil.sharedInstance.loadAccessToken(code)
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
        
        decisionHandler(WKNavigationActionPolicy.Cancel)
    }
    
}
