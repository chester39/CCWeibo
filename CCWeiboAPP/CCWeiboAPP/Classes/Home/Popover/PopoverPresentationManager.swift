//
//	PopoverPresentationManager.swift
//		CCWeiboAPP
//		Chen Chen @ August 10th, 2016
//

import UIKit

class PopoverPresentationManager: NSObject {

    // 控制器是否被显示
    private var isPresented = false
    // 弹出框尺寸
    var presentFrame = CGRectZero
    
}

extension PopoverPresentationManager: UIViewControllerTransitioningDelegate {
    
    /**
     衔接被显示和发起显示控制器方法
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let ppc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        ppc.presentFrame = presentFrame
        
        return ppc
    }
    
    /**
     转场控制器动画出现方法
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        NSNotificationCenter.defaultCenter().postNotificationName(kPopoverPresentationManagerDidPresented, object: self)
        
        return self
    }
    
    /**
     转场控制器动画消失方法
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        NSNotificationCenter.defaultCenter().postNotificationName(kPopoverPresentationManagerDidDismissed, object: self)
        
        return self
    }
    
}

extension PopoverPresentationManager: UIViewControllerAnimatedTransitioning {
    
    /**
     转场动画持续时间方法
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.5
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
     显示转场动画方法
     */
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            print("待显示的视图读取失败")
            return
        }
        
        transitionContext.containerView()?.addSubview(toView)
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toView.transform = CGAffineTransformIdentity
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
    /**
     消失转场动画方法
     */
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            print("待消失的视图读取失败")
            return
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
    
}
