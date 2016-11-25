//
//  OAuthViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit
import WebKit

import Cartography

class OAuthViewController: UIViewController {
    
    /// 授权网页视图
    private lazy var oauthView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.suppressesIncrementalRendering = true
        
        let webView = WKWebView(frame: kScreenFrame, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.navigationDelegate = self
        webView.sizeToFit()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        return webView
    }()
    
    /// 网页进度条
    fileprivate lazy var oauthProgressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
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
        NetworkingUtil.shared.loadRequestToken(webView: oauthView)
    }
    
    /**
     KVO观察者方法
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? NSObject == oauthView && keyPath! == "estimatedProgress" {
            let new: Float = change![.newKey] as! Float
            if new == 1.0 {
                oauthProgressView.isHidden = true
                oauthProgressView.setProgress(0.0, animated: false)
                
            } else {
                oauthProgressView.isHidden = false
                oauthProgressView.setProgress(new, animated: true)
            }
        }
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: MainColor]
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillButtonDidClick))
        
        view.addSubview(oauthView)
        view.addSubview(oauthProgressView)
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    @objc private func closeButtonDidClick() {
        
        NotificationCenter.default.post(name: Notification.Name(kRootViewControllerSwitched), object: false)
    }
    
    /**
     填充按钮点击方法
     */
    @objc private func fillButtonDidClick() {
        
        let jsString = "document.getElementById('userId').value = 'c910309c@sina.com';"
        oauthView.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
}

extension OAuthViewController: WKNavigationDelegate {
    
    /**
     网页开始加载方法
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        oauthProgressView.isHidden = false
    }
    
    /**
     网页结束加载方法
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
        navigationItem.title = webView.title
    }
    
    /**
     收到响应后跳转方法
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print(navigationAction.request)
        
        guard let urlString = navigationAction.request.url?.absoluteString else {
            return
        }
        
        if urlString.hasPrefix(kWeiboRedirectUri) == false {
            decisionHandler(.allow)
        }
        
        let key = "code="
        if urlString.contains(key) {
            let code = navigationAction.request.url?.query?.substring(from: key.endIndex)
            NetworkingUtil.shared.loadAccessToken(codeString: code)
            decisionHandler(.cancel)
        }
        
        decisionHandler(.cancel)
    }

}
