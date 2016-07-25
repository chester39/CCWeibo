//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - 初始化方法
    
    private lazy var composeButton: UIButton = { () -> UIButton in
        
        let button = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        button.addTarget(self, action: #selector(MainViewController.composeButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {

        super.viewDidLoad()

        tabBar.tintColor = UIColor.orangeColor()
        addChildControllerArray()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        let rect = composeButton.frame
        let barWidth = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRectMake(2 * barWidth, 0, barWidth, rect.height)
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
        
        guard let filePath = NSBundle.mainBundle().pathForResource("MainViewControllerSettings", ofType: "json") else {
            
            print("JSON文件不存在")
            return
        }
        guard let data = NSData(contentsOfFile: filePath) else {
            
            print("加载二进制数据失败")
            return
        }
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
            for dict in jsonObject {
                
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildController(vcName, title: title, imageName: imageName)
            }
        } catch {
                
            addChildController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildController("NullTableViewController", title: "", imageName: "")
            addChildController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildController("ProfileTableViewController", title: "我的", imageName: "tabbar_profile")
        }
    }
    
    /**
     添加控制器方法
     */
    func addChildController(childControllerName: String?, title: String?, imageName: String?) {
        
        guard let name = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            
            print("获取命名空间失败")
            return
        }
        var myClass: AnyObject? = nil
        if let vcName = childControllerName {
            
            myClass = NSClassFromString(name + "." + vcName)
        }
        guard let typeClass = myClass as? UITableViewController.Type else {
            
            print("class不是UITableViewController")
            return
        }
        
        let childController = typeClass.init()
        
        childController.title = title
        if let imgName = imageName {
            
            childController.tabBarItem.image = UIImage(named: imgName)
            childController.tabBarItem.selectedImage = UIImage(named: imgName + "_highlighted")
        }
        let nc = UINavigationController(rootViewController: childController)
        addChildViewController(nc)
    }
    
    /**
     编写按钮点击方法
     */
    @objc private func composeButtonClicked(button: UIButton) {
        
        print(button)
    }
}