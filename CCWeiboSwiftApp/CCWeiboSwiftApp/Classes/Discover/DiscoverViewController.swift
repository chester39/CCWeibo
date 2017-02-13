//
//  DiscoverViewController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 17th, 2016
//

import UIKit

import MBProgressHUD
import MJRefresh
import SDWebImage

class DiscoverViewController: BaseViewController {
    
    /// 微博数组
    var statusArray: [StatusViewModel]?
    /// 浏览视图转场管理器
    private lazy var browerPresentationManager: BrowserPresentationController = BrowserPresentationController(presentedViewController: self, presenting: nil)
    /// 搜索控制器
    fileprivate var searchVC = UISearchController()
    /// 搜索结果数组
    fileprivate var resultArray: [[String: Any]]?
    /// 头部视图
    fileprivate var headerView = DiscoverHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 270))
    /// 表格视图
    fileprivate var tableView = UITableView(frame: kScreenFrame, style: .plain)
    /// 微博Cell重用标识符
    fileprivate let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    fileprivate let retweetReuseIdentifier = "RetweetStatusCell"
    /// 搜索结果Cell重用标识符
    fileprivate let resultReuseIdentifier = "ResultCell"
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isUserLogin == false {
            vistorView.setupVisitorInformation(iconName: "visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与时事潮流擦肩而过")
            return
        }
        
        setupUI()
        loadWeiboStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pictureCellDidClick(notice:)), name: Notification.Name(kBrowserViewControllerShowed), object: nil)
    }
    
    /**
     反初始化方法
     */
    deinit {
        
        NotificationCenter.default.removeObserver(self)
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
        searchVC.searchBar.searchBarStyle = .minimal
        searchVC.searchBar.placeholder = "请输入搜索内容"
        searchVC.searchBar.sizeToFit()
        searchVC.delegate = self
        searchVC.searchResultsUpdater = self
        navigationItem.titleView = searchVC.searchBar
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.register(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultReuseIdentifier)
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadWeiboStatus))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    // MARK: - 按钮方法
    
    /**
     图片Cell点击方法
     */
    @objc private func pictureCellDidClick(notice: NSNotification) {
        
        guard let array = notice.userInfo!["middlePicture"] as? [URL] else {
            MBProgressHUD.showMessage(text: "图片获取失败", delay: 1.0)
            return
        }
        
        guard let index = notice.userInfo!["indexPath"] as? IndexPath else {
            MBProgressHUD.showMessage(text: "索引获取失败", delay: 1.0)
            return
        }
        
        guard let pictureCollectionView = notice.object as? PictureCollectionView else {
            MBProgressHUD.showMessage(text: "图片视图获取失败", delay: 1.0)
            return
        }
        
        let bvc = PictureBrowserController(urlArray: array, indexPath: index)
        bvc.transitioningDelegate = browerPresentationManager
        bvc.modalPresentationStyle = .custom
        browerPresentationManager.acquireDefaultData(indexPath: index, browserDelegate: pictureCollectionView)
        present(bvc, animated: true, completion: nil)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    @objc private func loadWeiboStatus() {
        
        NetworkingUtil.shared.loadPublicStatuses { (array, error) in
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
            
            self.tableView.mj_header.endRefreshing()
            self.statusArray = modelArray
            self.acquireImageCaches(viewModelArray: modelArray)
            
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
    
}

extension DiscoverViewController: UITableViewDataSource {
    
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
        
        if searchVC.isActive {
            return resultArray?.count ?? 0
        }
        
        return statusArray?.count ?? 0
    }
    
    /**
     每行内容方法
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchVC.isActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: resultReuseIdentifier, for: indexPath)
            if resultArray != nil && resultArray?.count != 0 {
                let dict = resultArray![indexPath.row]
                cell.textLabel?.text = dict[kScreenName] as? String
                cell.accessoryType = .disclosureIndicator
            }
            
            return cell
        }
        
        let viewModel = statusArray![indexPath.row]
        if viewModel.status.retweetedStatus != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: retweetReuseIdentifier, for: indexPath) as! RetweetStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: weiboReuseIdentifier, for: indexPath) as! WeiboStatusCell
            cell.viewModel = statusArray![indexPath.row]
            cell.delegate = self
            
            return cell
        }
    }
    
}

extension DiscoverViewController: UITableViewDelegate {
    
    /**
     选中行方法
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchVC.isActive {
            let dict = resultArray![indexPath.row]
            let id = dict[kUID] as! Int
            let urlString = "http://weibo.com/u/\(id)"
            
            let webVC = WebViewController()
            webVC.loadWithURLString(urlString: urlString)
            navigationController?.pushViewController(webVC, animated: false)
        }
    }
    
    /**
     开始滚动方法
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y + tableView.contentInset.top
        let panTranslationY = scrollView.panGestureRecognizer.translation(in: tableView).y
        if offsetY > 64 {
            if panTranslationY > 0 {
                navigationController?.setNavigationBarHidden(false, animated: true)
                
            } else {
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
            
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
}

extension DiscoverViewController: UISearchControllerDelegate {
    
    /**
     将要显示搜索控制器方法
     */
    func willPresentSearchController(_ searchController: UISearchController) {
        
        tableView.tableHeaderView = nil
    }
    
    /**
     将要消失搜索控制器方法
     */
    func willDismissSearchController(_ searchController: UISearchController) {
        
        tableView.tableHeaderView = headerView
    }
    
}

extension DiscoverViewController: UISearchResultsUpdating {
    
    /**
     更新搜索结果方法
     */
    func updateSearchResults(for searchController: UISearchController) {
        
        let text = searchController.searchBar.text
        NetworkingUtil.shared.searchWeiboUsers(search: text) { (array, error) in
            self.resultArray = array
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.async { 
            self.tableView.reloadData()
        }
    }
    
}

extension DiscoverViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURLString(cell: BaseStatusCell, urlString: String) {
        
        let webVC = WebViewController()
        webVC.loadWithURLString(urlString: urlString)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
}
