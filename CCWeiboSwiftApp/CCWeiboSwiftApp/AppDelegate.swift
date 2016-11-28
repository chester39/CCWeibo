//
//  AppDelegate.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 15th, 2016
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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: kScreenFrame)
        window?.backgroundColor = CommonLightColor
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = MainColor
        UITabBar.appearance().tintColor = MainColor
        
        if let options = launchOptions {
            launchWithNotification(options: options)
        }
        
        registerNotification()
        createLocalNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewController(notice:)), name: Notification.Name(kRootViewControllerSwitched), object: nil)
        
        return true
    }
    
    /**
     应用将要失去焦点方法
     */
    func applicationWillResignActive(_ application: UIApplication) {
        
        print(#function)
    }
    
    /**
     应用已经进入后台方法
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print(#function)
    }
    
    /**
     应用将要进入前台方法
     */
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        print(#function)
    }
    
    /**
     应用已经成为焦点方法
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
    }
    
    /**
     应用将要终止方法
     */
    func applicationWillTerminate(_ application: UIApplication) {
        
        print(#function)
    }
    
    // MARK: - 推送方法
    
    /**
     设备注册远程推送方法
     */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceString = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        deviceString = deviceString.replacingOccurrences(of: " ", with: "")
        print("设备注册成功，\(deviceString)")
    }
    
    /**
     注册远程推送失败方法
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("推送注册失败，\(error)")
    }
    
    /**
     接收本地推送方法
     */
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        let userInfo = notification.userInfo
        print(userInfo!)
        let adVC = AdViewController()
        window?.rootViewController = adVC
        application.applicationIconBadgeNumber -= 1
    }
    
    /**
     接收远程推送方法
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        application.applicationIconBadgeNumber -= 1
        completionHandler(.newData)
    }
    
    
    // MARK: - 控制器方法
    
    /**
     改变根控制器方法
     */
    func changeRootViewController(notice: Notification) {
        
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
        
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let defaults = UserDefaults.standard
        let sandboxVersion = (defaults.object(forKey: kAppVersion) as? String) ?? "0.0"
        if currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending {
            print("存在新版本")
            defaults.set(currentVersion, forKey: kAppVersion)
            
            return true
        }
        
        print("没有新版本")
        return false
    }
    
    // MARK: - 推送方法
    
    /**
     由推送启动方法
     */
    private func launchWithNotification(options: [UIApplicationLaunchOptionsKey: Any]) {
        
        if let remoteNotification = options[.remoteNotification] {
            let userInfo = remoteNotification as? [NSObject: Any]
            print(userInfo ?? "")
            let adVC = AdViewController()
            window?.rootViewController = adVC
            
        } else if let localNotification = options[.localNotification] {
            let userInfo = localNotification as? [NSObject: Any]
            print(userInfo ?? "")
            let adVC = AdViewController()
            window?.rootViewController = adVC
        }
    }
    
    /**
     注册推送方法
     */
    private func registerNotification() {
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: options, completionHandler: { granted, error in
                UIApplication.shared.registerForRemoteNotifications()
                if granted {
                    print("授权注册成功")
                    
                } else {
                    print("授权注册失败")
                }
            })
            center.getNotificationSettings(completionHandler: { setting in
                if setting.authorizationStatus == .authorized {
                    print("已授权")
                }
            })
            
        } else {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let setting = UIUserNotificationSettings.init(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /**
     创建本地推送方法
     */
    private func createLocalNotification() {
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.badge = 1
            content.title = "新的微博消息"
            content.subtitle = "查看最新的微博消息"
            content.body = "打开App，速度查看最新最快的微博消息！"
            content.userInfo = ["url": "http://weibo.com"]
            
            var components = DateComponents()
            components.hour = 20
            components.minute = 30
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: kWeiboNotification, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if error == nil {
                    print("本地推送成功")
                }
            })
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let pushDate = formatter.date(from: "20:30:00")
            
            let notification = UILocalNotification()
            notification.fireDate = pushDate
            notification.repeatInterval  = .weekday
            notification.timeZone = TimeZone.ReferenceType.default
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertTitle = "新的微博消息"
            notification.alertBody = "打开App，速度查看最新最快的微博消息！"
            notification.applicationIconBadgeNumber = 1
            notification.userInfo = ["url": "http://weibo.com"]
            UIApplication.shared.scheduleLocalNotification(notification)
            print("本地推送成功")
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /**
     响应推送方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            print("远程推送，\(userInfo)")
            let adVC = AdViewController()
            window?.rootViewController = adVC
            
        } else {
            print("本地推送，\(userInfo)")
            let adVC = AdViewController()
            window?.rootViewController = adVC
        }
        
        UIApplication.shared.applicationIconBadgeNumber -= 1
        completionHandler()
    }
    
    /**
     前台接收推送方法
     */
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
}
