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
    /// 数字标签
    private var numberLabel = UILabel(text: "", fontSize: 15, lines: 1)
    /// 变化约束组
    private var group = ConstraintGroup()
    /// 最大微博字数
    private let maxStatusCount = 140
    
    /// 表情键盘
    private lazy var emoticonKeyboardController: EmoticonKeyboardController = EmoticonKeyboardController { [unowned self] (emoticon) in
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
        addChildViewController(emoticonKeyboardController)
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
            button.action = #selector(itemButtonDidClick(_:))
        }

        view.addSubview(keyboardBar)
        
        numberLabel.hidden = true
        view.addSubview(numberLabel)
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
        
        constrain(numberLabel, keyboardBar) { (numberLabel, keyboardBar) in
            numberLabel.left == numberLabel.superview!.right - kViewMargin
            numberLabel.top == keyboardBar.top - kViewMargin
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
     键盘工具条按钮点击方法
     */
    @objc private func itemButtonDidClick(item: UIBarButtonItem) {
        
        for button in keyboardBar.items! {
            if button == item {
                item.tintColor = (item.tintColor == MainColor) ? AuxiliaryTextColor : MainColor
            } else {
                button.tintColor = AuxiliaryTextColor
            }
        }
        
        switch item {
        case keyboardBar.emoticonButton:
            statusView.resignFirstResponder()
            if statusView.inputView != nil {
                statusView.inputView = nil
                
            } else {
                statusView.inputView = emoticonKeyboardController.view
            }
            
            statusView.becomeFirstResponder()
            
        default:
            break
        }

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
        
        let currentCount = statusView.acquireEmoticonString().characters.count
        let leftCount = maxStatusCount - currentCount
        numberLabel.text = "\(leftCount)"
        if leftCount <= 10 {
            numberLabel.hidden = false
            if leftCount < 0 {
                navigationItem.rightBarButtonItem?.enabled = false
                numberLabel.textColor = MainColor
                
            } else {
                navigationItem.rightBarButtonItem?.enabled = true
                numberLabel.textColor = CommonDarkColor
            }
        }
    }
    
    /**
     滑动视图将要抓拽方法
     */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        statusView.resignFirstResponder()
    }
}