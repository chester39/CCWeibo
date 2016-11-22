//
//  MainViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 15th, 2016
//

import UIKit

import SwiftyJSON

class MainViewController: UITabBarController {

    /// 发布按钮
    private lazy var composeButton: UIButton = {
        let button = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        button.addTarget(self, action: #selector(composeButtonDidClick(button:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tabBar.tintColor = MainColor
        addChildControllerArray()
    }
    
    /**
     视图将要显示方法
     */
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        let rect = composeButton.frame
        let barWidth = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * barWidth, y: 0, width: barWidth, height: rect.height)
    }
    
    // MARK: - 控制器方法
    
    /**
     添加控制器组方法
     */
    func addChildControllerArray() {
        
        guard let filePath = Bundle.main.path(forResource: "MainViewControllerSettings", ofType: "json") else {
            print("JSON文件不存在")
            return
        }
        
        do {
            if let data = try String(contentsOfFile: filePath).data(using: .utf8) {
                let json = JSON(data: data)
                if let jsonArray = json.arrayObject {
                    for object in jsonArray {
                        let dict = object as! [String: Any]
                        let title = dict["title"] as? String
                        let vcName = dict["vcName"] as? String
                        let imageName = dict["imageName"] as? String
                        addChildController(childControllerName: vcName, title: title, imageName: imageName)
                    }
                }
            }
            
        } catch {
            print("加载二进制数据失败")
        }
        
    }
    
    /**
     添加控制器方法
     */
    func addChildController(childControllerName: String?, title: String?, imageName: String?) {
        
        guard let name = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("获取命名空间失败")
            return
        }
        
        var myClass: Any? = nil
        if let vcName = childControllerName {
            myClass = NSClassFromString(name + "." + vcName)
        }
        
        guard let typeClass = myClass as? UIViewController.Type else {
            print("class不是UIViewController")
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
    
    // MARK: - 按钮方法
    
    /**
     发布按钮点击方法
     */
    @objc private func composeButtonDidClick(button: UIButton) {
        
        let cvc = ComposeViewController()
        let nc = UINavigationController()
        nc.addChildViewController(cvc)
        present(nc, animated: false, completion: nil)
    }
    
}

