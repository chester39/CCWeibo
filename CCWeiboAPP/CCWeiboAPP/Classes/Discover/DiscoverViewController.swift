//
//	DiscoverViewController.swift
//		CCWeiboAPP
//		Chen Chen @ July 21st, 2016
//

import UIKit

import MBProgressHUD
import MJRefresh
import SDWebImage

class DiscoverViewController: BaseViewController {

    /// 微博数组
    var statusArray: [StatusViewModel]?
    /// 浏览视图转场管理器
    private lazy var browerPresentationManager: BrowserPresentationController = BrowserPresentationController()
    /// 搜索控制器
    private var searchVC = UISearchController()
    /// 搜索结果数组
    private var resultArray: [[String: AnyObject]]?
    /// 头部视图
    private var headerView = DiscoverHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 270))
    /// 微博Cell重用标识符
    private let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    private let retweetReuseIdentifier = "RetweetStatusCell"
    /// 搜索结果Cell重用标识符
    private let resultReuseIdentifier = "ResultCell"

    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与时事潮流擦肩而过")
            return
        }
        
        setupUI()
        loadWeiboStatus()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pictureCellDidClick(_:)), name: kBrowserViewControllerShowed, object: nil)
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        searchVC = UISearchController(searchResultsController: nil)
        searchVC.dimsBackgroundDuringPresentation = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.definesPresentationContext = true
        searchVC.searchBar.searchBarStyle = .Minimal
        searchVC.searchBar.placeholder = "请输入搜索内容"
        searchVC.searchBar.sizeToFit()
        searchVC.delegate = self
        searchVC.searchResultsUpdater = self
        navigationItem.titleView = searchVC.searchBar
        
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = headerView
        tableView.registerClass(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.registerClass(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: resultReuseIdentifier)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_header.automaticallyChangeAlpha = true
    }
    
    // MARK: - 按钮方法
    
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
        
        NetworkingUtil.sharedInstance.loadPublicStatuses { (array, error) in
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
            
            self.tableView.mj_header.endRefreshing()
            self.statusArray = modelArray
            self.acquireImageCaches(modelArray)
            
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
    
}

extension DiscoverViewController {
    
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
        
        if searchVC.active {
            return resultArray?.count ?? 0
        }
        
        return statusArray?.count ?? 0
    }
    
    /**
     每行内容方法
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if searchVC.active {
            let cell = tableView.dequeueReusableCellWithIdentifier(resultReuseIdentifier, forIndexPath: indexPath)
            if resultArray != nil && resultArray?.count != 0 {
                let dict = resultArray![indexPath.row]
                cell.textLabel?.text = dict[kScreenName] as? String
                cell.accessoryType = .DisclosureIndicator
            }
            
            return cell
        }
        
        let viewModel = statusArray![indexPath.row]
        if viewModel.status.retweetedStatus != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(retweetReuseIdentifier, forIndexPath: indexPath) as! RetweetStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(weiboReuseIdentifier, forIndexPath: indexPath) as! WeiboStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self

            return cell
        }
    }
    
}

extension DiscoverViewController {
    
    /**
     选中行方法
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if searchVC.active {
            let dict = resultArray![indexPath.row]
            let id = dict[kUID] as! Int
            let urlString = "http://weibo.com/u/\(id)"
            let url = NSURL(string: urlString)!
            
            let webVC = WebViewController(url: url)
            navigationController?.pushViewController(webVC, animated: false)
        }
    }
    
}

extension DiscoverViewController: UISearchControllerDelegate {
    
    /**
     将要显示搜索控制器方法
     */
    func willPresentSearchController(searchController: UISearchController) {
        
        tableView.tableHeaderView = nil
    }
    
    /**
     将要消失搜索控制器方法
     */
    func willDismissSearchController(searchController: UISearchController) {
        
        tableView.tableHeaderView = headerView
    }
    
}

extension DiscoverViewController: UISearchResultsUpdating {
    
    /**
     更新搜索结果方法
     */
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let text = searchController.searchBar.text
        NetworkingUtil.sharedInstance.searchWeiboUsers(text) { (array, error) in
            self.resultArray = array
            self.tableView.reloadData()
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
}

extension DiscoverViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURL(cell: BaseStatusCell, url: NSURL) {
        
        let webVC = WebViewController(url: url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}
