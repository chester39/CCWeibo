//
//  WelcomeViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 25th, 2016
//

import UIKit

class WelcomeViewController: UIViewController {

    /// 欢迎视图
    private var welcomeView = WelcomeView(frame: kScreenFrame)
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view = welcomeView
    }
    
    /**
     视图已经显示方法
     */
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        welcomeView.startAnimation()
    }
    
}
