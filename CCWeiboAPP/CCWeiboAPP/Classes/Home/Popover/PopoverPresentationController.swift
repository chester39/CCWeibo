//
//	iOS培训
//		小码哥
//		Chen Chen @ August 10th, 2016
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    // 弹出框尺寸
    var presentFrame = CGRectZero
    
    // 蒙版按钮懒加载
    private lazy var coverButton: UIButton = {
        let button = UIButton(type: UIButtonType.System)
        button.frame = kScreenFrame
        button.backgroundColor = UIColor.clearColor()
        
        return button
    }()
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    /**
     容器视图将要布局子视图方法
     */
    override func containerViewWillLayoutSubviews() {
        
        presentedView()?.frame = presentFrame
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.addTarget(self, action: #selector(coverButtonDidClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: - 按钮方法
    
    /**
     蒙版按钮点击方法
     */
    @objc private func coverButtonDidClick() {
        
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
