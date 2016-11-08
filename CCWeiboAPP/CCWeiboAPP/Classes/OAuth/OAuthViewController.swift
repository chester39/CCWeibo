//
//	OAuthViewController.swift
//		CCWeiboAPP
//		Chen Chen @ August 18th, 2016
//

import UIKit
import WebKit

import Cartography

class OAuthViewController: UIViewController {
    
    /// 授权网页视图
    private lazy var oauthView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.suppressesIncrementalRendering = true
        configuration.mediaPlaybackRequiresUserAction = false
        
        let webView = WKWebView(frame: kScreenFrame, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.navigationDelegate = self
        webView.sizeToFit()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        return webView
    }()
    
    /// 网页进度条
    private lazy var oauthProgressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .Default)
        progress.frame = CGRect(x: 0, y: kTopHeight, width: kScreenWidth, height: 2)
        progress.trackTintColor = ClearColor
        progress.progressTintColor = MainColor
        
        return progress
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        NetworkingUtil.sharedInstance.loadRequestToken(oauthView)
    }
    
    /**
     KVO观察者方法
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if object as? NSObject == oauthView && keyPath! == "estimatedProgress" {
            let new: Float = change![NSKeyValueChangeNewKey] as! Float
            if new == 1.0 {
                oauthProgressView.hidden = true
                oauthProgressView.setProgress(0.0, animated: false)
                
            } else {
                oauthProgressView.hidden = false
                oauthProgressView.setProgress(new, animated: true)
            }
        }
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: MainColor]
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(fillButtonDidClick))
        
        view.addSubview(oauthView)
        view.addSubview(oauthProgressView)
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(kRootViewControllerSwitched, object: false)
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
        
        oauthProgressView.hidden = false
    }
    
    /**
     网页结束加载方法
     */
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        navigationItem.title = webView.title
    }
    
    /**
     收到响应后跳转方法
     */
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
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
