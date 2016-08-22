//
//	iOS培训
//		小码哥
//		Chen Chen @ August 11th, 2016
//

import Foundation
import UIKit

// MARK: - 界面常数

// 视图外间距
let kViewMargin: CGFloat = 20
// 视图内边距
let kViewPadding: CGFloat = 10
// 屏幕尺寸
let kScreenFrame: CGRect = UIScreen.mainScreen().bounds
// 屏幕宽度
let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
// 屏幕高度
let kScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
// 状态栏高度
let kStatusBarHeight: CGFloat = 20
// 导航栏高度
let kNavigationBarHeight: CGFloat = 44
// 可用高度
let kAvailableHeight: CGFloat = (kStatusBarHeight + kNavigationBarHeight)

// MARK: - 微博API常数

// 微博开放平台URL
let kWeiboURL: String  = "https://api.weibo.com/"
// 微博OAuth授权Key
let kWeiboAppKey: String = "2576232033"
// 微博OAuth授权Secret
let kWeiboAppSecret: String = "3839ebe10107d44f1d8064fbc397b696"
// 微博OAuth授权回调地址
let kWeiboRedirectUri: String  = "https://github.com/chester39"
// 用户账户文件名
let kUserAccountFileName: String = "UserAccount.plist"
// 授权使用令牌
let kAccessToken: String = "access_token"
// 授权生命周期
let kExpiresIn: String = "expires_in"
// 授权用户ID
let kUID: String = "uid"
// 授权过期具体时间
let kExpiresDate: String = "expires_date"
// 用户昵称
var kScreenName: String = "screen_name"
// 用户头像地址
var kAvatarLarge: String = "avatar_large"

// MARK: - 通知常数

// 弹出框已经显示
let kPopoverPresentationManagerDidPresented: String = "PopoverPresentationManagerDidPresented"
// 弹出框已经消失
let kPopoverPresentationManagerDidDismissed: String = "PopoverPresentationManagerDidDismissed"
// 切换到根控制器
let kChangeRootViewController: String = "ChangeRootViewController"
// 应用版本
let kAppVersion: String = "AppVersion"
