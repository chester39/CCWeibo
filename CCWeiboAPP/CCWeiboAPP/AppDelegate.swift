//
//	AppDelegate.swift
//      CCWeiboAPP
//		Chen Chen @ July 18th, 2016
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 应用窗口
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

        print(#function)
    }

    /**
     应用将要终止方法
     */
    func applicationWillTerminate(application: UIApplication) {

        print(#function)
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
    
}

