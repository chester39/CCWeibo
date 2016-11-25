//
//  HomeViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit

import MBProgressHUD
import MJRefresh
import SDWebImage

class HomeViewController: BaseViewController {

    /// 微博数组
    var statusArray: [StatusViewModel]?
    /// 最后一条微博与否
    fileprivate var isLastStatus = false
    /// 表格视图
    fileprivate var tableView = UITableView(frame: kScreenFrame, style: .plain)
    /// 浏览视图转场管理器
    private lazy var browerPresentationManager: BrowserPresentationController = BrowserPresentationController(presentedViewController: self, presenting: nil)
    /// 微博Cell重用标识符
    fileprivate let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    fileprivate let retweetReuseIdentifier = "RetweetStatusCell"
    
    /// 刷新提醒标签
    private var tipLabel: UILabel = {
        let label = UILabel(text: "没有更多微博", fontSize: 15, lines: 1)
        label.backgroundColor = MainColor
        label.textColor = CommonLightColor
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: kTopHeight - kNavigationBarHeight, width: kScreenWidth, height: kNavigationBarHeight)
        label.isHidden = true
        
        return label
    }()
    
    /// 标题按钮
    private lazy var titleButton: UIButton = {
        let button = NavigationTitleButton()
        let title = UserAccount.loadUserAccount()?.screenName
        button.setTitle(title, for: .normal)
//        button.addTarget(self, action: #selector(titleButtonDidClick(button:)), for: .touchUpInside)
        
        return button
    }()
    
//    /// 标题按钮转场管理器
//    private lazy var popoverPresentationManager: PopoverPresentationManager = {
//        let manager = PopoverPresentationManager()
//        let presentWidth: CGFloat = kViewDistance
//        let presentHeight: CGFloat = 250
//        let presentX: CGFloat = (kScreenWidth - presentWidth) / 2
//        let presentY: CGFloat = kViewAdapter
//        manager.presentFrame = CGRect(x: presentX, y: presentY, width: presentWidth, height: presentHeight)
//        
//        return manager
//    }()
    
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
        
        setupNavigation()
        setupTableView()
        loadWeiboStatus()
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化导航栏方法
     */
    private func setupNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(friendButtonDidClick))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(qrcodeButtonDidClick))
        navigationItem.titleView = titleButton
        navigationController?.view.insertSubview(tipLabel, belowSubview: navigationController!.navigationBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(titleButtonDidChange), name: Notification.Name(kPopoverPresentationManagerDidPresented), object: browerPresentationManager)
        NotificationCenter.default.addObserver(self, selector: #selector(titleButtonDidChange), name: Notification.Name(kPopoverPresentationManagerDidDismissed), object: browerPresentationManager)
        NotificationCenter.default.addObserver(self, selector: #selector(pictureCellDidClick(notice:)), name: Notification.Name(kBrowserViewControllerShowed), object: nil)
    }
    
    /**
     初始化表格视图方法
     */
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.register(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
    }
    
    // MARK: - 按钮方法
    
    /**
     标题按钮改变方法
     */
    @objc private func titleButtonDidChange() {
        
        titleButton.isSelected = !titleButton.isSelected
    }
    
//    /**
//     标题按钮点击方法
//     */
//    @objc private func titleButtonDidClick(button: NavigationTitleButton) {
//        
//        let popoverVC = PopoverViewController()
//        popoverVC.transitioningDelegate = popoverPresentationManager
//        popoverVC.modalPresentationStyle = .custom
//        presentViewController(popoverVC, animated: true, completion: nil)
//    }
    
    /**
     好友按钮点击方法
     */
    @objc private func friendButtonDidClick() {
        
        print(#function)
    }
    
//    /**
//     二维码按钮点击方法
//     */
//    @objc private func qrcodeButtonDidClick() {
//        
//        let qrcVC = QRCodeViewController()
//        let qrcNC = UINavigationController()
//        qrcNC.addChildViewController(qrcVC)
//        presentViewController(qrcNC, animated: false, completion: nil)
//    }
    
    /**
     图片Cell点击方法
     */
    @objc private func pictureCellDidClick(notice: Notification) {
        
        guard let array = notice.userInfo!["middlePicture"] as? [URL] else {
            MBProgressHUD.showMessage(text: "图片获取失败", delay: 1.0)
            return
        }
        
        guard let indexPath = notice.userInfo!["indexPath"] as? IndexPath else {
            MBProgressHUD.showMessage(text: "索引获取失败", delay: 1.0)
            return
        }
        
        guard let pictureCollectionView = notice.object as? PictureCollectionView else {
            MBProgressHUD.showMessage(text: "图片视图获取失败", delay: 1.0)
            return
        }
        
        let pictureBrowserVC = PictureBrowserController(urlArray: array, indexPath: indexPath)
        pictureBrowserVC.transitioningDelegate = browerPresentationManager
        pictureBrowserVC.modalPresentationStyle = .custom
        browerPresentationManager.acquireDefaultData(indexPath: indexPath, browserDelegate: pictureCollectionView)
        present(pictureBrowserVC, animated: true, completion: nil)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    @objc fileprivate func loadWeiboStatus() {
        
        var sinceID = statusArray?.first?.status.weiboID ?? 0
        var maxID = 0
        if isLastStatus {
            sinceID = 0
            maxID = statusArray?.last?.status.weiboID ?? 0
        }
        
        NetworkingUtil.shared.loadWeiboStatuses(sinceID: sinceID, maxID: maxID) { (array, error) in
            if error != nil {
                MBProgressHUD.showMessage(text: "微博数据获取失败", delay: 1.0)
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
            self.acquireImageCaches(viewModelArray: modelArray)
            self.showRefreshStatus(count: modelArray.count)
            
            self.tableView.reloadData()
        }
    }
    
    /**
     获取微博图片缓存方法
     */
    private func acquireImageCaches(viewModelArray: [StatusViewModel]) {
        
        let group = DispatchGroup()
        for viewModel in viewModelArray {
            guard let pictureArray = viewModel.thumbnailPictureArray else {
                continue
            }
            
            for url in pictureArray {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: .retryFailed, progress: nil, completed: { (image, error, _, _, _) in
                    group.leave()
                })
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    /**
     显示刷新提醒方法
     */
    private func showRefreshStatus(count: Int) {
        
        tipLabel.text = (count == 0) ? "没有更多微博" : "\(count) 条微博"
        tipLabel.isHidden = false
        
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: kNavigationBarHeight)
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.tipLabel.transform = .identity
            }, completion: { _ in
                self.tipLabel.isHidden = true
            })
        }
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    /**
     每组行数方法
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArray?.count ?? 0
    }
    
    /**
     每行内容方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = statusArray![indexPath.row]
        if viewModel.status.retweetedStatus != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: retweetReuseIdentifier, for: indexPath) as! RetweetStatusCell
            cell.viewModel = viewModel
            cell.delegate = self
            if indexPath.row == (statusArray!.count - 1) {
                isLastStatus = true
                loadWeiboStatus()
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: weiboReuseIdentifier, for: indexPath) as! WeiboStatusCell
            cell.viewModel = viewModel
            cell.delegate = self
            if indexPath.row == (statusArray!.count - 1) {
                isLastStatus = true
                loadWeiboStatus()
            }
            
            return cell
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    /**
     选中行方法
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewModel = statusArray![indexPath.row]
//        let detailVC = DetailViewController(viewModel: viewModel)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension HomeViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURL(cell: BaseStatusCell, url: URL) {
        
        let webVC = WebViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}
