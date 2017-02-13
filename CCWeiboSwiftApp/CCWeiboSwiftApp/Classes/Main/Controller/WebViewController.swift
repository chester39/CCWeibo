//
//  WebViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit
import WebKit

import Cartography

class WebViewController: UIViewController {
    
    /// 网页视图
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        configuration.suppressesIncrementalRendering = true
        
        let webView = WKWebView(frame: kScreenFrame, configuration: configuration)
        webView.isOpaque = false
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
    
    /// 后退按钮
    private lazy var backItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(MainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        
        button.addTarget(self, action: #selector(backItemDidClick), for: .touchUpInside)
        button.sizeToFit()
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        item.customView = button
        
        return item
    }()
    
    /// 关闭按钮
    private lazy var closeItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "关闭"
        item.style = .done
        item.target = self
        item.action = #selector(closeItemDidClick)
        
        return item
    }()
    
    // MARK: - 初始化方法
    
    /**
     网页URL初始化方法
     */
    init() {
        
        super.init(nibName: nil, bundle: nil)
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
    }
    
    /**
     KVO观察者方法
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? NSObject == webView && keyPath! == "estimatedProgress" {
            let new: Float = change![.newKey] as! Float
            if new == 1.0 {
                webProgressView.setProgress(1.0, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.webProgressView.isHidden = true
                    self.webProgressView.setProgress(0.0, animated: false)
                })
                
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
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(refreshItemDidClick))
        
        view.backgroundColor = CommonLightColor
        view.addSubview(webView)
        view.addSubview(webProgressView)
    }
    
    /**
     读取URL方法
     */
    func loadWithURLString(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - 按钮方法
    
    /**
     后退按钮点击方法
     */
    @objc private func backItemDidClick() {
        
        if webView.canGoBack {
            webView.goBack()
            closeItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], for: .normal)
            navigationItem.leftBarButtonItems = [backItem, closeItem]
            
        } else {
            closeItemDidClick()
        }
    }
    
    /**
     关闭按钮点击方法
     */
    @objc private func closeItemDidClick() {
        
//        if ((navigationController?.viewControllers)!.first is AdViewController) || ((navigationController?.viewControllers)!.first is WebViewController) {
//
//            
//        } else {
            _ = navigationController?.popViewController(animated: true)
//        }
    }
    
    /**
     刷新按钮点击方法
     */
    @objc private func refreshItemDidClick() {
        
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
