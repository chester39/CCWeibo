//
//	iOS培训
//		小码哥
//		Chen Chen @ August 10th, 2016
//

import UIKit

class PopoverPresentationManager: NSObject {

    /**
     控制器是否被展示
     */
    private var isPresent = false
    /**
     弹出框尺寸
     */
    var presentFrame = CGRectZero
    
}

extension PopoverPresentationManager: UIViewControllerTransitioningDelegate {
    
    /**
     衔接被展示和发起展示控制器方法
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let ppc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        ppc.presentFrame = presentFrame
        return ppc
    }
    
    /**
     转场控制器出现动画方法
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName("opoverPresentationManagerDidPresented", object: self)
        return self
    }
    
    /**
     转场控制器消失动画方法
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName("opoverPresentationManagerDidDismissed", object: self)
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
        
        if isPresent {
        
        } else {
            
        }
    }
    
}
