//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

class BaseTableViewController: UITableViewController {

    /**
     用户是否登录
     */
    var isLogin = false
    /**
     访客视图
     */
    var vistorView = VisitorView(frame: UIScreen.mainScreen().bounds)
    
    // MARK: - 系统方法
    
    /**
     读取视图方法
     */
    override func loadView() {
        
        isLogin ? super.loadView() : setuplVisitorView()
        self.view.backgroundColor = UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    }
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    // MARK: - 自定义方法
    
    /**
     设置访客视图方法
     */
    private func setuplVisitorView() {
        
        view = vistorView
        vistorView.loginButton.addTarget(self, action: #selector(loginButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        vistorView.registerButton.addTarget(self, action: #selector(registerButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerButtonClicked(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginButtonClicked(_:)))
    }
    
    // MARK: - 监听方法
    
    /**
     登录按钮点击方法
     */
    @objc private func loginButtonClicked(button: UIButton) {
        
        print(#function)
    }
    
    /**
     注册按钮点击方法
     */
    @objc private func registerButtonClicked(button: UIButton) {
        
        print(#function)
    }
}
