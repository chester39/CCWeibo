//
//  PopoverPresentationManager.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 28th, 2016
//

import UIKit

class PopoverPresentationManager: NSObject {

    /// 控制器是否被显示
    fileprivate var isPresented = false
    /// 弹出框尺寸
    var presentFrame = CGRect.zero
    
}

extension PopoverPresentationManager: UIViewControllerTransitioningDelegate {
    
    /**
     衔接被显示和发起显示控制器方法
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let ppc = PopoverPresentationController(presentedViewController: presented, presenting: presenting)
        ppc.presentFrame = presentFrame
        
        return ppc
    }
    
    /**
     转场控制器动画出现方法
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        NotificationCenter.default.post(name: Notification.Name(kPopoverPresentationManagerDidPresented), object: self)
        
        return self
    }
    
    /**
     转场控制器动画消失方法
     */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        NotificationCenter.default.post(name: Notification.Name(kPopoverPresentationManagerDidDismissed), object: self)
        
        return self
    }
    
}

extension PopoverPresentationManager: UIViewControllerAnimatedTransitioning {
    
    /**
     转场动画持续时间方法
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    /**
     转场动画方法
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented {
            willPresentedController(transitionContext: transitionContext)
            
        } else {
            willDismissedController(transitionContext: transitionContext)
        }
    }
    
    /**
     将要显示转场动画方法
     */
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to) else {
            print("待显示的视图读取失败")
            return
        }
        
        transitionContext.containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = .identity
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     将要消失转场动画方法
     */
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else {
            print("待消失的视图读取失败")
            return
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            transitionContext.completeTransition(true)

        }
    }
    
}
