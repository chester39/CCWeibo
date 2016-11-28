//
//  PopoverPresentationController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 18th, 2016
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    /// 弹出框尺寸
    var presentFrame = CGRect.zero
    
    /// 蒙版按钮
    private lazy var coverButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = kScreenFrame
        button.backgroundColor = ClearColor
        
        return button
    }()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    /**
     容器视图将要布局子视图方法
     */
    override func containerViewWillLayoutSubviews() {
        
        presentedView?.frame = presentFrame
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(coverButtonDidClick), for: .touchUpInside)
    }
    
    // MARK: - 按钮方法
    
    /**
     蒙版按钮点击方法
     */
    @objc private func coverButtonDidClick() {
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}
