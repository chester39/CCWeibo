//
//  BaseViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 18th, 2016
//

import UIKit

class BaseViewController: UIViewController {

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
        vistorView.registerButton.addTarget(self, action: #selector(registerButtonDidClick(button:)), for: .touchUpInside)
        vistorView.loginButton.addTarget(self, action: #selector(loginButtonDidClick(button:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerButtonDidClick(button:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginButtonDidClick(button:)))
    }
    
    // MARK: - 按钮方法
    
    /**
     登录按钮点击方法
     */
    @objc private func loginButtonDidClick(button: UIButton) {
        
        let oauthVC = OAuthViewController()
        let oauthNC = UINavigationController()
        oauthNC.addChildViewController(oauthVC)
        present(oauthNC, animated: true, completion: nil)
    }
    
    /**
     注册按钮点击方法
     */
    @objc private func registerButtonDidClick(button: UIButton) {
        
        print(#function)
    }

}
