//
//  WebViewController.swift
//		CCWeiboAPP
//		Chen Chen @ October 8th, 2016
//

import UIKit
import WebKit

import Cartography

class WebViewController: UIViewController {
    
    /// 网页URL
    private var url: NSURL?
    
    /// 网页视图
    private lazy var webView: WKWebView = {
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
    
    /// 进度条
    private lazy var webProgressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .Default)
        progress.frame = CGRect(x: 0, y: kAvailableHeight, width: kScreenWidth, height: 2)
        progress.trackTintColor = ClearColor
        progress.progressTintColor = MainColor
        
        return progress
    }()
    
    // MARK: - 初始化方法
    
    /**
     网页URL初始化方法
     */
    init(url: NSURL?) {
        
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    /**
     KVO观察者方法
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if object as? NSObject == webView && keyPath! == "estimatedProgress" {
            let new: Float = change![NSKeyValueChangeNewKey] as! Float
            if new == 1.0 {
                webProgressView.hidden = true
                webProgressView.setProgress(0.0, animated: false)
                
            } else {
                webProgressView.hidden = false
                webProgressView.setProgress(new, animated: true)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .Plain, target: self, action: #selector(refreshButtonDidClick))
        
        view.addSubview(webView)
        view.addSubview(webProgressView)
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    func closeButtonDidClick() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     刷新按钮点击方法
     */
    func refreshButtonDidClick() {
        
        webView.reload()
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    /**
     网页开始加载方法
     */
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        webProgressView.hidden = false
    }
    
    /**
     网页结束加载方法
     */
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        navigationItem.title = webView.title
    }
    
    /**
     收到响应后跳转与否方法
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
