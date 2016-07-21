//
//	iOS培训
//		小码哥
//		Chen Chen @ July 18th, 2016
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - 系统代理方法
    
    /**
     应用启动方法
     */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
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
    
}

