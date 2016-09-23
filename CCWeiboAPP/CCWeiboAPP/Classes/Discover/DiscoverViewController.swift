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
        
        setupTableView()
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
     初始化表格视图方法
     */
    private func setupTableView() {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerClass(WeiboStatusCell.self, forCellReuseIdentifier: kWeiboStatusReuseIdentifier)
        tableView.registerClass(RetweetStatusCell.self, forCellReuseIdentifier: kRetweetStatusReuseIdentifier)
        
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
        
        return statusArray?.count ?? 0
    }
    
    /**
     每行内容方法
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let viewModel = statusArray![indexPath.row]
        if viewModel.status.retweetedStatus != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(kRetweetStatusReuseIdentifier, forIndexPath: indexPath) as! RetweetStatusCell
            cell.viewModel = statusArray![indexPath.row]
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(kWeiboStatusReuseIdentifier, forIndexPath: indexPath) as! WeiboStatusCell
            cell.viewModel = statusArray![indexPath.row]
            
            return cell
        }
    }
    
}
