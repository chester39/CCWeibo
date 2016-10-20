//
//  BrowserPresentationController.swift
//		CCWeiboAPP
//		Chen Chen @ September 5th, 2016
//

import UIKit

protocol BrowserPresentationDelegate: NSObjectProtocol {
    
    /**
     浏览图片视图创建方法
     */
    func browerPresentationWillShowImageView(browserPresentationController: BrowserPresentationController, indexPath: NSIndexPath) -> UIImageView
    
    /**
     浏览图片相对尺寸方法
     */
    func browerPresentationWillFromFrame(browserPresentationController: BrowserPresentationController, indexPath: NSIndexPath) -> CGRect
    
    /**
     浏览图片绝对尺寸方法
     */
    func browerPresentationWillToFrame(browserPresentationController: BrowserPresentationController, indexPath: NSIndexPath) -> CGRect
    
}

class BrowserPresentationController: UIPresentationController {
    
    /// 控制器是否被显示
    private var isPresented = false
    /// Cell索引
    private var indexPath: NSIndexPath?
    /// BrowserPresentationDelegate代理
    weak var browserDelegate: BrowserPresentationDelegate?
    
    /**
     自定义初始化方法
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController?) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    /**
     获取默认数据方法
     */
    func acquireDefaultData(indexPath: NSIndexPath, browserDelegate: BrowserPresentationDelegate) {
        
        self.indexPath = indexPath
        self.browserDelegate = browserDelegate
    }

}

extension BrowserPresentationController: UIViewControllerTransitioningDelegate {
    
    /**
     衔接被显示和发起显示控制器方法
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return BrowserPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    /**
     转场控制器动画出现方法
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    /**
     转场控制器动画消失方法
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
}

extension BrowserPresentationController: UIViewControllerAnimatedTransitioning {
 
    /**
     转场动画持续时间方法
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 1.0
    }
    
    /**
     转场动画方法
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented {
            willPresentedController(transitionContext)
            
        } else {
            willDismissedController(transitionContext)
        }
    }
    
    /**
     将要显示转场动画方法
     */
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning) {
        
        assert(indexPath != nil, "必须设置被点击cell的indexPath")
        assert(browserDelegate != nil, "必须设置代理")
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            print("待显示的视图读取失败")
            return
        }
        
        let imageView = browserDelegate!.browerPresentationWillShowImageView(self, indexPath: indexPath!)
        imageView.frame = browserDelegate!.browerPresentationWillFromFrame(self, indexPath: indexPath!)
        transitionContext.containerView().addSubview(toView)
        let toFrame = browserDelegate!.browerPresentationWillToFrame(self, indexPath: indexPath!)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = toFrame
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.containerView().addSubview(toView)
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     将要消失转场动画方法
     */
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning) {
        
        transitionContext.completeTransition(true)
    }
}
