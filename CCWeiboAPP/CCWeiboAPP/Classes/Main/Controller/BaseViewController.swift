//
//	BaseViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 26th, 2016
//

import UIKit

class BaseViewController: UITableViewController {
    
    /// 用户登录与否
    var isUserLogin = UserAccount.isUserLogin()
    /// 访客视图
    var vistorView = VisitorView(frame: kScreenFrame)
    
    // MARK: - 系统方法
    
    /**
     读取视图方法
     */
    override func loadView() {
        
        isUserLogin ? super.loadView() : setuplVisitorView()
    }
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    // MARK: - 界面方法
    
    /**
     设置访客视图方法
     */
    private func setuplVisitorView() {
        
        view = vistorView
        vistorView.registerButton.addTarget(self, action: #selector(registerButtonDidClick(_:)), forControlEvents: .TouchUpInside)
        vistorView.loginButton.addTarget(self, action: #selector(loginButtonDidClick(_:)), forControlEvents: .TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(registerButtonDidClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(loginButtonDidClick(_:)))
    }
    
    // MARK: - 按钮方法
    
    /**
     登录按钮点击方法
     */
    @objc private func loginButtonDidClick(button: UIButton) {
        
        let oaVC = OAuthViewController()
        let oaNC = UINavigationController()
        oaNC.addChildViewController(oaVC)
        presentViewController(oaNC, animated: true, completion: nil)
    }
    
    /**
     注册按钮点击方法
     */
    @objc private func registerButtonDidClick(button: UIButton) {
        
        print(#function)
    }
    
}