//
//	iOS培训
//		小码哥
//		Chen Chen @ July 26th, 2016
//

import UIKit

import Alamofire

class BaseTableViewController: UITableViewController {
    
    // 用户是否登录
    var isUserLogin = UserAccount.isUserLogin()
    // 访客视图
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
    
    // MARK: - 自定义方法
    
    /**
     设置访客视图方法
     */
    private func setuplVisitorView() {
        
        view = vistorView
        vistorView.registerButton.addTarget(self, action: #selector(registerButtonDidClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        vistorView.loginButton.addTarget(self, action: #selector(loginButtonDidClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerButtonDidClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginButtonDidClick(_:)))
    }
    
    // MARK: - 监听方法
    
    /**
     登录按钮点击方法
     */
    @objc private func loginButtonDidClick(button: UIButton) {
        
        let oaVC = OAuthViewController()
        presentViewController(oaVC, animated: true, completion: nil)
    }
    
    /**
     注册按钮点击方法
     */
    @objc private func registerButtonDidClick(button: UIButton) {
        
        Alamofire.request(Method.GET, "https://api.500px.com/v1/photos").responseJSON() {
            reponse in
            guard let json = reponse.result.value else {
                return
            }
            print("\(json)")
        }
    }
    
}
