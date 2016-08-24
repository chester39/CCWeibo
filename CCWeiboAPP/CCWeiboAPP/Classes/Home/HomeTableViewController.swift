//
//	iOS培训
//		小码哥
//		Chen Chen @ July 21st, 2016
//

import UIKit

import Alamofire
import MBProgressHUD

class HomeTableViewController: BaseTableViewController {
    
    // 微博数组
    var statusArray: [StatusModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Cell重用标识符
    private let reuseIdentifier = "WeiboStatusCell"
    
    // 标题按钮懒加载
    private lazy var titleButton: UIButton = {
        
        let button = TitleButton()
        let title = UserAccount.loadUserAccount()?.screenName
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(titleButtonDidClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    // 转场管理器懒加载
    private lazy var presentationManger: PopoverPresentationManager = {
        
        let manager = PopoverPresentationManager()
        let presentWidth: CGFloat = 200
        let presentHeight: CGFloat = 250
        let presentX: CGFloat = (kScreenWidth - presentWidth) / 2
        let presentY: CGFloat = 50
        manager.presentFrame = CGRect(x: presentX, y: presentY, width: presentWidth, height: presentHeight)
        
        return manager
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation(nil, title: "关注一些人后，再回到这里看看有什么惊喜")
            return
        }
        
        setupNavigation()
        loadWeiboData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.registerClass(WeiboStatusCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 导航栏方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(friendButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(qrcodeButtonDidClick))
        navigationItem.titleView = titleButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChange), name: kPopoverPresentationManagerDidPresented, object: presentationManger)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChange), name: kPopoverPresentationManagerDidDismissed, object: presentationManger)
    }
    
    // MARK: - 按钮方法
    
    /**
     标题按钮改变方法
     */
    @objc private func titleButtonDidChange() {
        
        titleButton.selected = !titleButton.selected
    }
    
    /**
     标题按钮点击方法
     */
    @objc private func titleButtonDidClick(button: TitleButton) {
        
        let popoverVC = PopoverViewController()
        popoverVC.transitioningDelegate = presentationManger
        popoverVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    /**
     左边按钮点击方法
     */
    @objc private func friendButtonDidClick() {
        
        print(#function)
    }
    
    /**
     二维码按钮点击方法
     */
    @objc private func qrcodeButtonDidClick() {
        
        let qrcVC = QRCodeViewController()
        let qrcNC = UINavigationController()
        qrcNC.addChildViewController(qrcVC)
        presentViewController(qrcNC, animated: true, completion: nil)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    private func loadWeiboData() {
        
        loadWeiboStatuses { (array, error) -> () in
            
            if error != nil {
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.label.text = "获取微博数据失败"
                hud.hideAnimated(true, afterDelay: 2.0)
            }
            
            guard let weiboArray = array else {
                return
            }
            
            var modelArray = [StatusModel]()
            for dict in weiboArray {
                let status = StatusModel(dict: dict)
                modelArray.append(status)
            }
            
            self.statusArray = modelArray
        }
    }
    
    /**
     读取微博接口
     */
    private func loadWeiboStatuses(finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        let path = "2/statuses/home_timeline.json"
        let parameters = ["access_token": UserAccount.loadUserAccount()!.accessToken!]
        Alamofire.request(Method.GET, kWeiboBaseURL + path, parameters: parameters).responseJSON { response in
            guard let array = (response.result.value as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                finished(array: nil, error: NSError(domain: "com.github.chester", code: 1000, userInfo: ["message": "获取数据失败"]))
                return
            }
            
            finished(array: array, error: nil)
        }
    }
    
}

extension HomeTableViewController {
    
    /**
     共有组数方法
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    /**
     每组行数方法
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArray?.count ?? 0
    }
    
    /**
     每行内容方法
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! WeiboStatusCell
        cell.status = statusArray![indexPath.row]
        return cell
    }
    
}