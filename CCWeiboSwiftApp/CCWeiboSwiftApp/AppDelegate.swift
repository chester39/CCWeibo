//
//  AppDelegate.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 15th, 2016
//

import UIKit

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
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().tintColor = MainColor
        UITabBar.appearance().tintColor = MainColor
        
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
        
        print(#function)
    }
    
    /**
     应用将要终止方法
     */
    func applicationWillTerminate(_ application: UIApplication) {
        
        print(#function)
    }
    
}
