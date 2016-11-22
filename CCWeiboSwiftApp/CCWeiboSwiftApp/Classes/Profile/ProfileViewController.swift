//
//  ProfileViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit

class ProfileViewController: BaseViewController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation(iconName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，显示给其他人")
            return
        }
    }

}
