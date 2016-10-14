//
//	Const.swift
//		CCWeiboAPP
//		Chen Chen @ August 11th, 2016
//

import Foundation
import UIKit

// MARK: - 界面常数

/// 视图窄边缘: 5
let kViewEdge: CGFloat = 5
/// 视图内边距: 10
let kViewPadding: CGFloat = 10
/// 视图宽边缘: 20
let kViewBorder: CGFloat = 20
/// 视图外间距: 30
let kViewMargin: CGFloat = 30
/// 视图适应距离: 60
let kViewAdapter: CGFloat = 60
/// 视图标准距离: 100
let kViewStandard: CGFloat = 100
/// 视图移动距离: 160
let kViewDistance: CGFloat = 160
/// 屏幕尺寸: iPhone4/4s: 320-480 iPhone5/5s: 320-568 iPhone6/6s: 375-667 iPhone6/6s Plus: 414-736
let kScreenFrame: CGRect = UIScreen.mainScreen().bounds
/// 屏幕宽度: 320/375/414
let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
/// 屏幕高度: 480/568/667/736
let kScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
/// 状态栏高度: 20
let kStatusBarHeight: CGFloat = 20
/// 导航栏高度: 44
let kNavigationBarHeight: CGFloat = 44
/// 顶端高度: 64
let kTopHeight: CGFloat = 64
/// 可用高度: 64
let kAvailableHeight: CGFloat = kScreenHeight - kTopHeight
/// 键盘高度: 238
let kKeyboardHeight: CGFloat = 238

// MARK: - 微博API常数

/// 微博开放平台URL
let kWeiboBaseURL: String  = "https://api.weibo.com/"
/// 微博OAuth授权Key
let kWeiboAppKey: String = "2576232033"
/// 微博OAuth授权Secret
let kWeiboAppSecret: String = "3839ebe10107d44f1d8064fbc397b696"
/// 微博OAuth授权回调地址
let kWeiboRedirectUri: String  = "https://github.com/chester39"
/// 用户账户文件名
let kUserAccountFileName: String = "UserAccount.plist"
/// 授权使用令牌
let kAccessToken: String = "access_token"
/// 授权生命周期
let kExpiresIn: String = "expires_in"
/// 授权用户ID
let kUID: String = "uid"
/// 授权过期具体时间
let kExpiresDate: String = "expires_date"
/// 用户
let kUser: String = "user"
/// 用户昵称
let kScreenName: String = "screen_name"
/// 用户头像地址
let kAvatarLarge: String = "avatar_large"
/// 用户简介
let kDescription: String = "description"
/// 用户粉丝数
let kFollowersCount: String = "followers_count"
/// 用户关注数
let kFriendsCount: String = "friends_count"
/// 用户微博数
let kStatusesCount: String = "statuses_count"
/// 微博通用ID
let kWeiboID: String = "id"
/// 用户认证类型
let kVerifiedType: String = "verified_type"
/// 用户会员等级
let kMbRank: String = "mbrank"
/// 微博创建时间
let kCreatedAt: String = "created_at"
/// 微博信息内容
let kWeiboText: String = "text"
/// 微博来源
let kWeiboSource: String = "source"
/// 微博配图数组
let kPictureURLArray: String = "pic_urls"
/// 微博配图URL
let kThumbnailPicture: String = "thumbnail_pic"
/// 转发数
let kRepostsCount: String = "reposts_count"
/// 评论数
let kCommentsCount: String = "comments_count"
/// 表态数
let kAttitudesCount: String = "attitudes_count"
/// 转发微博
let kRetweetedStatus: String = "retweeted_status"
/// 评论楼层
let kFloorNumber: String = "floor_number"

// MARK: - 通知常数

/// 弹出框已经显示
let kPopoverPresentationManagerDidPresented: String = "PopoverPresentationManagerDidPresented"
/// 弹出框已经消失
let kPopoverPresentationManagerDidDismissed: String = "PopoverPresentationManagerDidDismissed"
/// 根控制器切换
let kRootViewControllerSwitched: String = "RootViewControllerSwitched"
/// 应用版本
let kAppVersion: String = "AppVersion"
/// 图片浏览器展示
let kBrowserViewControllerShowed: String = "BrowserViewControllerShowed"
