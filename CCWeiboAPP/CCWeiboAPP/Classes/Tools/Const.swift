//
//	iOS培训
//		小码哥
//		Chen Chen @ August 11th, 2016
//

import Foundation
import UIKit

/**
 用户是否登录
 */
var kIsUserLogin = false
/**
 视图外间距
 */
let kViewMargin: CGFloat = 20
/**
 视图内边距
 */
let kViewPadding: CGFloat = 10
/**
 屏幕宽度
 */
let kScreenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
/**
 屏幕高度
 */
let kScreenHeight : CGFloat = UIScreen.mainScreen().bounds.size.height
/**
 状态栏高度
 */
let kStatusBarHeight : CGFloat = 20
/**
 导航栏高度
 */
let kNavigationBarHeight : CGFloat = 44
/**
 可用高度
 */
let kAvailableHeight : CGFloat = (kStatusBarHeight + kNavigationBarHeight)
/**
 弹出框已经显示
 */
let kPopoverPresentationManagerDidPresented = "PopoverPresentationManagerDidPresented"
/**
 弹出框已经消失
 */
let kPopoverPresentationManagerDidDismissed = "PopoverPresentationManagerDidDismissed"