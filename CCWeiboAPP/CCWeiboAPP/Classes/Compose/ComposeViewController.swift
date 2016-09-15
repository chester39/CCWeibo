//
//  ComposeViewController.swift
//		CCWeiboAPP
//		Chen Chen @ September 6th, 2016
//

import UIKit

import Cartography
import MBProgressHUD

class ComposeViewController: UIViewController {

    /// 标题视图
    private var titleView = TitleView(frame: CGRect(x: 0, y: 0, width: kViewStandard, height: kNavigationBarHeight))
    /// 复合文本视图
    private var statusView = PlaceholderTextView()
    /// 键盘工具条
    private var keyboardBar = KeyboardToolbar()
    /// 变化约束组
    private var group = ConstraintGroup()
    /// 表情键盘
    private lazy var emoticonKeyboard: EmoticonKeyboardController = EmoticonKeyboardController { [unowned self] (emoticon) in
        self.statusView.insertEmoticon(emoticon)
        self.textViewDidChange(self.statusView)
    }
    
    /// 发送按钮
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
        
        statusView.becomeFirstResponder()
    }
    
    /**
     视图将要消失方法
     */
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        statusView.resignFirstResponder()
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
        
        statusView.delegate = self
        view.addSubview(statusView)
    
        for button in keyboardBar.items! {
            button.target = self
        }

        keyboardBar.pictureButton.action = #selector(pictureButtonDidClick)
        keyboardBar.emoticonButton.action = #selector(emoticonButtonDidClick)
        view.addSubview(keyboardBar)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(statusView, keyboardBar) { (statusView, keyboardBar) in
            statusView.edges == inset(statusView.superview!.edges, 0)
            
            keyboardBar.width == kScreenWidth
            keyboardBar.height == kNavigationBarHeight
            keyboardBar.left == keyboardBar.superview!.left
            
        }
        
        constrain(keyboardBar, replace: group) { (keyboardBar) in
            keyboardBar.bottom == keyboardBar.superview!.bottom
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
        
        let text = statusView.acquireEmoticonString()
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
        
        keyboardBar.pictureButton.tintColor = (keyboardBar.pictureButton.tintColor == MainColor) ? AuxiliaryTextColor : MainColor
    }
    
    /**
     表情按钮点击方法
     */
    @objc private func emoticonButtonDidClick() {
        
        keyboardBar.emoticonButton.tintColor = (keyboardBar.emoticonButton.tintColor == MainColor) ? AuxiliaryTextColor : MainColor
        statusView.resignFirstResponder()
        
        if statusView.inputView != nil {
            statusView.inputView = nil
            
        } else {
            statusView.inputView = emoticonKeyboard.view
        }
        
        statusView.becomeFirstResponder()
    }
    
    // MARK: - 通知方法
    
    /**
     键盘将要改变方法
     */
    func keyboardWillChange(notice: NSNotification) {
        
        let rect = notice.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let offsetY = kScreenHeight - rect.origin.y
        
        constrain(keyboardBar, replace: group) { (toolBar) in
            toolBar.bottom == toolBar.superview!.bottom - offsetY
        }
        
        let curve = notice.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        UIView.animateWithDuration(0.2) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve.integerValue)!)
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
        statusView.placeholderLabel.hidden = textView.hasText()
    }
    
    /**
     滑动视图将要抓拽方法
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        statusView.resignFirstResponder()
    }
}
