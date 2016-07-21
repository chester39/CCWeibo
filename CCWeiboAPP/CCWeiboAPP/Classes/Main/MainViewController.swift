//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let hvc = HomeTableViewController()
        hvc.tabBarItem.title = "首页"
        hvc.tabBarItem.image = UIImage(named: "tabbar_home")
        hvc.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
        tabBar.tintColor = UIColor.orangeColor()
        
       addChildControllerArray()
    }

    /**
     收到内存警告方法
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 控制器方法
    
    /**
     添加控制器组方法
     */
    func addChildControllerArray() {
        
        addChildController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildController(ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
    }
    
    /**
     添加控制器方法
     */
    func addChildController(childController: UIViewController, title: String, imageName: String) {
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let nc = UINavigationController(rootViewController: childController)
        addChildViewController(nc)
    }
    
}