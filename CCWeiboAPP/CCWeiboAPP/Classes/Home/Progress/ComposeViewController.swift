//
//  ComposeViewController.swift
//		CCWeiboAPP
//		Chen Chen @ September 6th, 2016
//

import UIKit

import Cartography
import MBProgressHUD

class ComposeViewController: UIViewController {

    // 标题视图
    private var titleView = TitleView(frame: CGRect(x: 0, y: 0, width: kViewStandard, height: kNavigationBarHeight))
    // 占位符文本视图
    private var textView = PlaceholderTextView()
    
    // 发送按钮
    private lazy var composeItem: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "发送"
        button.target = self
        button.action = #selector(composeButtonDidClick)
        button.enabled = false
        
        return button
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 按钮方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = composeItem
        navigationItem.titleView = titleView
        
        textView.font = UIFont.systemFontOfSize(18)
        textView.alwaysBounceVertical = true
        textView.delegate = self
        view.addSubview(textView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(textView) { (textView) in
            textView.edges == inset(textView.superview!.edges, 0)
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    @objc private func closeButtonDidClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     发送按钮点击方法
     */
    @objc private func composeButtonDidClick() {
        
        let text = textView.text
        NetworkingUtil.sharedInstance.sendWeiboStatuses(text) { (object, error) in
            if error != nil {
                MBProgressHUD.showMessage("微博发送失败", delay: 2.0)
            }
            
            MBProgressHUD.showMessage("微博发送成功", delay: 2.0)
            self.closeButtonDidClick()
        }
    }

}

extension ComposeViewController: UITextViewDelegate {
    
    /**
     文本视图已经改变方法
     */
    func textViewDidChange(textView: UITextView) {
        
        composeItem.enabled = textView.hasText()
    }
}
