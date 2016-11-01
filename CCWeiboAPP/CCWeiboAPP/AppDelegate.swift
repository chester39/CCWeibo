//
//	AppDelegate.swift
//      CCWeiboAPP
//		Chen Chen @ July 18th, 2016
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// 应用窗口
    var window: UIWindow?

    // MARK: - 系统代理方法
    
    /**
     应用启动方法
     */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: kScreenFrame)
        window?.backgroundColor = CommonLightColor
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = MainColor
        UITabBar.appearance().tintColor = MainColor
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeRootViewController(_:)), name: kRootViewControllerSwitched, object: nil)
        registerNotification()
        createLocalNotification()
        
        return true
    }

    /**
     应用将要失去焦点方法
     */
    func applicationWillResignActive(application: UIApplication) {

        print(#function)
    }

    /**
     应用已经进入后台方法
     */
    func applicationDidEnterBackground(application: UIApplication) {

        print(#function)
    }

    /**
     应用将要进入前台方法
     */
    func applicationWillEnterForeground(application: UIApplication) {

        print(#function)
    }

    /**
     应用已经成为焦点方法
     */
    func applicationDidBecomeActive(application: UIApplication) {

        let number = application.applicationIconBadgeNumber
        if number != 0 {
            application.applicationIconBadgeNumber = 0
        }
        
        application.cancelAllLocalNotifications()
    }

    /**
     应用将要终止方法
     */
    func applicationWillTerminate(application: UIApplication) {

        print(#function)
    }
    
    // MARK: - 推送方法
    
    /**
     设备注册远程推送方法
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        print("设备注册成功，\(deviceToken)")
    }
    
    /**
     注册远程推送失败方法
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print("推送注册失败，\(error)")
    }
    
    /**
     接收本地推送方法
     */
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        
    }
    
    /**
     接收远程推送方法
     */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        completionHandler(.NewData)
    }
    
    // MARK: - 自定义方法
    
    /**
     改变根控制器方法
     */
    func changeRootViewController(notice: NSNotification) {
        
        window?.rootViewController = notice.object as! Bool ? MainViewController() : WelcomeViewController()
    }
    
    /**
     默认控制器方法
     */
    private func defaultViewController() -> UIViewController {
        
        if UserAccount.isUserLogin() {
            return isNewVersion() ? NewFeatureController() : WelcomeViewController()
        }
        
        return MainViewController()
    }
    
    /**
     是否新版本方法
     */
    private func isNewVersion() -> Bool {
        
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let defaults = NSUserDefaults.standardUserDefaults()
        let sandboxVersion = (defaults.objectForKey(kAppVersion) as? String) ?? "0.0"
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            print("存在新版本")
            defaults.setObject(currentVersion, forKey: kAppVersion)
            
            return true
        }
        
        print("没有新版本")
        return false
    }
    
    /**
     注册推送方法
     */
    private func registerNotification() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.currentNotificationCenter()
            center.delegate = self
            let options: UNAuthorizationOptions = [.Alert, .Badge, .Sound]
            center.requestAuthorizationWithOptions(options, completionHandler: { (granted, error) in
                UIApplication.sharedApplication().registerForRemoteNotifications()
                if granted {
                    print("授权注册成功")
                } else {
                    print("授权注册失败")
                }
            })
            
            center.getNotificationSettingsWithCompletionHandler({ (setting) in
                if setting.authorizationStatus == .Authorized {
                    print("已授权")
                }
            })
            
        } else {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let setting = UIUserNotificationSettings(forTypes: types, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(setting)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    
    /**
     创建本地推送方法
     */
    private func createLocalNotification() {
        
        let components = NSDateComponents()
        components.weekday = 3
        components.hour = 18
        components.minute = 18
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.badge = 1
            content.title = "新的微博消息"
            content.subtitle = "查看最新的微博消息"
            content.body = "打开App，速度查看最新最快的微博消息！"
            content.userInfo = ["url": "http://weibo.com"]
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            let trigger = UNCalendarNotificationTrigger(dateMatchingComponents: components, repeats: true)
            let request = UNNotificationRequest(identifier: kWeiboNotification, content: content, trigger: trigger)
            UNUserNotificationCenter.currentNotificationCenter().addNotificationRequest(request, withCompletionHandler: { (error) in
                if error == nil {
                    print("本地推送成功")
                }
            })
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
 
    /**
     响应推送方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        if (response.notification.request.trigger?.isKindOfClass(UNPushNotificationTrigger.self)) != nil {
            print("远程推送")
            
        } else {
            print("本地推送")
        }
        completionHandler()
    }
    
    /**
     前台接收推送方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        if (notification.request.trigger?.isKindOfClass(UNPushNotificationTrigger.self)) != nil {
            print("远程推送")
            
        } else {
            print("本地推送")
        }
        
        completionHandler([.Alert, .Badge, .Sound])
    }
    
}
