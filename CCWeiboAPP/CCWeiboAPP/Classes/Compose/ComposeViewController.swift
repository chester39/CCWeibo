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
    // 键盘工具条
    private var toolBar = KeyboardToolbar()
    // 表情键盘
    private var emoticonKeyboard = EmoticonKeyboardController()
    // 变化约束组
    private var group = ConstraintGroup()
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        addChildViewController(emoticonKeyboard)
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    /**
     视图将要消失方法
     */
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(closeButtonDidClick))
        navigationItem.rightBarButtonItem = composeItem
        navigationItem.titleView = titleView
        
        textView.delegate = self
        view.addSubview(textView)
    
        for button in toolBar.items! {
            button.target = self
        }

        toolBar.pictureButton.action = #selector(pictureButtonDidClick)
        toolBar.emoticonButton.action = #selector(emoticonButtonDidClick)
        view.addSubview(toolBar)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(textView, toolBar) { (textView, toolBar) in
            textView.edges == inset(textView.superview!.edges, 0)
            
            toolBar.width == kScreenWidth
            toolBar.height == kNavigationBarHeight
            toolBar.left == toolBar.superview!.left
            
        }
        
        constrain(toolBar, replace: group) { (toolBar) in
            toolBar.bottom == toolBar.superview!.bottom
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
    
    /**
     图片按钮点击方法
     */
    @objc private func pictureButtonDidClick() {
        
        toolBar.pictureButton.tintColor = (toolBar.pictureButton.tintColor == MainColor) ? AuxiliaryTextColor : MainColor
    }
    
    /**
     表情按钮点击方法
     */
    @objc private func emoticonButtonDidClick() {
        
        toolBar.emoticonButton.tintColor = (toolBar.emoticonButton.tintColor == MainColor) ? AuxiliaryTextColor : MainColor
        textView.resignFirstResponder()
        if textView.inputView != nil {
            textView.inputView = nil
            
        } else {
            textView.inputView = emoticonKeyboard.view
        }
        
        textView.becomeFirstResponder()
    }
    
    // MARK: - 通知方法
    
    /**
     键盘将要改变方法
     */
    func keyboardWillChange(notice: NSNotification) {
        
        let rect = notice.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let offsetY = kScreenHeight - rect.origin.y
        
        constrain(toolBar, replace: group) { (toolBar) in
            toolBar.bottom == toolBar.superview!.bottom - offsetY
        }
        
        UIView.animateWithDuration(0.2) {
            self.view.layoutIfNeeded()
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
    
    /**
     滑动视图将要抓拽方法
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        textView.resignFirstResponder()
    }
}
