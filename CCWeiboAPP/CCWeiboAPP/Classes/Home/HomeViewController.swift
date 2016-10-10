//
//	HomeViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 21st, 2016
//

import UIKit

import MBProgressHUD
import MJRefresh
import SDWebImage

class HomeViewController: BaseViewController {
    
    /// 微博数组
    var statusArray: [StatusViewModel]?
    /// 最后一条微博与否
    private var isLastStatus = false
    /// 浏览视图转场管理器
    private var browerPresentationManager = BrowserPresentationController()
    /// 微博Cell重用标识符
    private let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    private let retweetReuseIdentifier = "RetweetStatusCell"
    
    /// 刷新提醒标签
    private var tipLabel: UILabel = {
        let label = UILabel(text: "没有更多微博", fontSize: 15, lines: 1)
        label.backgroundColor = MainColor
        label.textColor = CommonLightColor
        label.textAlignment = .Center
        label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarHeight)
        label.hidden = true
        
        return label
    }()
    
    /// 标题按钮
    private lazy var titleButton: UIButton = {
        let button = TitleButton()
        let title = UserAccount.loadUserAccount()?.screenName
        button.setTitle(title, forState: .Normal)
        button.addTarget(self, action: #selector(titleButtonDidClick(_:)), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    /// 标题按钮转场管理器
    private lazy var popoverPresentationManager: PopoverPresentationManager = {
        let manager = PopoverPresentationManager()
        let presentWidth: CGFloat = kViewDistance
        let presentHeight: CGFloat = 250
        let presentX: CGFloat = (kScreenWidth - presentWidth) / 2
        let presentY: CGFloat = kViewAdapter
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
        setupTableView()
        loadWeiboStatus()
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(friendButtonDidClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(qrcodeButtonDidClick))
        navigationItem.titleView = titleButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChange), name: kPopoverPresentationManagerDidPresented, object: popoverPresentationManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleButtonDidChange), name: kPopoverPresentationManagerDidDismissed, object: popoverPresentationManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pictureCellDidClick(_:)), name: kBrowserViewControllerShowed, object: nil)
        
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
    }
    
    /**
     初始化表格视图方法
     */
    private func setupTableView() {
        
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.registerClass(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_header.automaticallyChangeAlpha = true

        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_footer.automaticallyChangeAlpha = true
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
        popoverVC.transitioningDelegate = popoverPresentationManager
        popoverVC.modalPresentationStyle = .Custom
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    /**
     好友按钮点击方法
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
        presentViewController(qrcNC, animated: false, completion: nil)
    }
    
    /**
     图片Cell点击方法
     */
    @objc private func pictureCellDidClick(notice: NSNotification) {
        
        guard let array = notice.userInfo!["middlePicture"] as? [NSURL] else {
            MBProgressHUD.showMessage("图片获取失败", delay: 1.0)
            return
        }
        
        guard let index = notice.userInfo!["indexPath"] as? NSIndexPath else {
            MBProgressHUD.showMessage("索引获取失败", delay: 1.0)
            return
        }
        
        guard let pictureCollectionView = notice.object as? PictureCollectionView else {
            MBProgressHUD.showMessage("图片视图获取失败", delay: 1.0)
            return
        }
        
        let bvc = BrowserViewController(urlArray: array, indexPath: index)
        bvc.transitioningDelegate = browerPresentationManager
        bvc.modalPresentationStyle = .Custom
        browerPresentationManager.acquireDefaultData(index, browserDelegate: pictureCollectionView)
        presentViewController(bvc, animated: true, completion: nil)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    @objc private func loadWeiboStatus() {
        
        var sinceID = statusArray?.first?.status.weiboID ?? 0
        var maxID = 0
        if isLastStatus {
            sinceID = 0
            maxID = statusArray?.last?.status.weiboID ?? 0
        }
        
        NetworkingUtil.sharedInstance.loadWeiboStatuses(sinceID, maxID: maxID) { (array, error) -> () in
            if error != nil {
                MBProgressHUD.showMessage("微博数据获取失败", delay: 1.0)
            }
            
            guard let weiboArray = array else {
                return
            }
            
            var modelArray = [StatusViewModel]()
            for dict in weiboArray {
                let status = StatusModel(dict: dict)
                let viewModel = StatusViewModel(status: status)
                modelArray.append(viewModel)
            }
            
            if sinceID != 0 {
                self.statusArray = modelArray + self.statusArray!
                
            } else if maxID != 0 {
                self.statusArray = self.statusArray! + modelArray
                
            } else {
                self.statusArray = modelArray
            }
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.acquireImageCaches(modelArray)
            self.showRefreshStatus(modelArray.count)
            self.tableView.reloadData()
        }
    }
    
    /**
     获取微博图片缓存方法
     */
    private func acquireImageCaches(viewModelArray: [StatusViewModel]) {
        
        let group = dispatch_group_create()
        for viewModel in viewModelArray {
            guard let pictureArray = viewModel.thumbnailPictureArray else {
                continue
            }
            
            for url in pictureArray {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .RetryFailed, progress: nil, completed: { (image, error, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    /**
     显示刷新提醒方法
     */
    private func showRefreshStatus(count: Int) {
        
        tipLabel.text = (count == 0) ? "没有更多微博" : "\(count) 条微博"
        tipLabel.hidden = false
        
        UIView.animateWithDuration(1.0, animations: {
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, kNavigationBarHeight)
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    self.tipLabel.transform = CGAffineTransformIdentity
                }) { (_) in
                    self.tipLabel.hidden = true
                }
        }
    }
    
}

extension HomeViewController {
    
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
        
        let viewModel = statusArray![indexPath.row]
        if viewModel.status.retweetedStatus != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(retweetReuseIdentifier, forIndexPath: indexPath) as! RetweetStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self
            if indexPath.row == (statusArray!.count - 1) {
                isLastStatus = true
                loadWeiboStatus()
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(weiboReuseIdentifier, forIndexPath: indexPath) as! WeiboStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self
            if indexPath.row == (statusArray!.count - 1) {
                isLastStatus = true
                loadWeiboStatus()
            }
            
            return cell
        }
    }
    
}

extension HomeViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURL(cell: BaseStatusCell, url: NSURL) {
        
        let webVC = WebViewController(url: url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}