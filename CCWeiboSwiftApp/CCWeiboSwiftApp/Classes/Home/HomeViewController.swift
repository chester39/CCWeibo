//
//  HomeViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit

class HomeViewController: BaseViewController {

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation(iconName: nil, title: "关注一些人后，再回到这里看看有什么惊喜")
            return
        }
    }
    
}
