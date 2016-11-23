//
//  WebViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit
import WebKit

import Cartography

class WebViewController: UIViewController {
    
    /// 网页URL
    private var url: URL?
    
    /// 网页视图
    private lazy var webView: WKWebView = {
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
    
    /// 进度条
    fileprivate lazy var webProgressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.frame = CGRect(x: 0, y: kTopHeight, width: kScreenWidth, height: 2)
        progress.trackTintColor = ClearColor
        progress.progressTintColor = MainColor
        
        return progress
    }()
    
    // MARK: - 初始化方法
    
    /**
     网页URL初始化方法
     */
    init(url: URL?) {
        
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
        
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    /**
     KVO观察者方法
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? NSObject == webView && keyPath! == "estimatedProgress" {
            let new: Float = change![.newKey] as! Float
            if new == 1.0 {
                webProgressView.isHidden = true
                webProgressView.setProgress(0.0, animated: false)
                
            } else {
                webProgressView.isHidden = false
                webProgressView.setProgress(new, animated: true)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(refreshButtonDidClick))
        
        view.addSubview(webView)
        view.addSubview(webProgressView)
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    @objc private func closeButtonDidClick() {
        
        navigationController?.popViewController(animated: true)
    }
    
    /**
     刷新按钮点击方法
     */
    @objc private func refreshButtonDidClick() {
        
        webView.reload()
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    /**
     网页开始加载方法
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        webProgressView.isHidden = false
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
        decisionHandler(.allow)
    }
    
}
