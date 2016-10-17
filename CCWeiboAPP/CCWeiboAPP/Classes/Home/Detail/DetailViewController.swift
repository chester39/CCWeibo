//
//  DetailViewController.swift
//		CCWeiboAPP
//		Chen Chen @ October 14th, 2016
//

import UIKit

import MBProgressHUD

class DetailViewController: UIViewController {

    /// 微博视图模型
    private var viewModel: StatusViewModel?
    /// 评论数组
    private var commentArray: [CommentModel]?
    /// 表格视图
    private var tableView = UITableView(frame: kScreenFrame, style: .Plain)
    /// 微博Cell重用标识符
    private let weiboReuseIdentifier = "WeiboStatusCell"
    /// 转发微博Cell重用标识符
    private let retweetReuseIdentifier = "RetweetStatusCell"
    /// 评论Cell重用标识符
    private let commentReuseIdentifier = "CommentCell"
    
    /// 头视图
    private var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kViewMargin))
        view.backgroundColor = MainColor
        
        return view
    }()

    // MARK: - 初始化方法
    
    /**
     图片数组和索引初始化方法
     */
    init(viewModel: StatusViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        loadCommentStatus()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {

        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(WeiboStatusCell.self, forCellReuseIdentifier: weiboReuseIdentifier)
        tableView.registerClass(RetweetStatusCell.self, forCellReuseIdentifier: retweetReuseIdentifier)
        tableView.registerClass(CommentCell.self, forCellReuseIdentifier: commentReuseIdentifier)
        view.addSubview(tableView)
    }
    
    /**
     按钮点击方法
     */
    @objc private func buttonDidClick(button: UIButton) {
        
        for view in headerView.subviews {
            if view.frame.size.height == 1 {
                view.removeFromSuperview()
            }
        }
        
        let line = UIView()
        line.frame.origin.x = button.frame.origin.x
        line.frame.origin.y = kViewMargin - 2
        line.frame.size.width = kViewAdapter
        line.frame.size.height = 1
        line.backgroundColor = CommonLightColor
        headerView.addSubview(line)
    }
    
    // MARK: - 数据方法
    
    /**
     读取微博数据方法
     */
    private func loadCommentStatus() {
        
        let id = viewModel!.status.weiboID
        NetworkingUtil.sharedInstance.loadStatusComments(id) { (array, error) in
            if error != nil {
                MBProgressHUD.showMessage("评论数据获取失败", delay: 1.0)
            }
            
            guard let commentArray = array else {
                return
            }
            
            var modelArray = [CommentModel]()
            for dict in commentArray {
                let comment = CommentModel(dict: dict)
                modelArray.append(comment)
            }
            
            self.commentArray = modelArray
            
            self.tableView.reloadData()
        }
    }

}

extension DetailViewController: UITableViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    /**
     每组行数方法
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
            
        } else {
            return commentArray?.count ?? 0
        }
    }
    
    /**
     每行内容方法
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if viewModel!.status.retweetedStatus != nil {
                let cell = tableView.dequeueReusableCellWithIdentifier(retweetReuseIdentifier, forIndexPath: indexPath) as! RetweetStatusCell
                cell.viewModel = viewModel!
                cell.delegate = self
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(weiboReuseIdentifier, forIndexPath: indexPath) as! WeiboStatusCell
                cell.viewModel = viewModel!
                cell.delegate = self
                
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(commentReuseIdentifier, forIndexPath: indexPath) as! CommentCell
            let comment = commentArray![indexPath.row]
            cell.comment = comment
            
            return cell
        }
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    /**
     每组头视图内容方法
     */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let retweetButton = UIButton(frame: CGRect(x: 0, y: 0, width: kViewAdapter, height: kViewMargin))
            retweetButton.titleLabel?.font = UIFont.systemFontOfSize(12)
            retweetButton.setTitle("转发 \(viewModel!.status.repostsCount)", forState: .Normal)
            retweetButton.addTarget(self, action: #selector(buttonDidClick(_:)), forControlEvents: .TouchUpInside)
            headerView.addSubview(retweetButton)
            
            let commentButton = UIButton(frame: CGRect(x: kViewAdapter, y: 0, width: kViewAdapter, height: kViewMargin))
            commentButton.titleLabel?.font = UIFont.systemFontOfSize(12)
            commentButton.setTitle("评论 \(viewModel!.status.commentsCount)", forState: .Normal)
            commentButton.addTarget(self, action: #selector(buttonDidClick(_:)), forControlEvents: .TouchUpInside)
            buttonDidClick(commentButton)
            headerView.addSubview(commentButton)
            
            let likeButton = UIButton(frame: CGRect(x: kScreenWidth - kViewAdapter, y: 0, width: kViewAdapter, height: kViewMargin))
            likeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
            likeButton.setTitle("赞 \(viewModel!.status.attitudesCount)", forState: .Normal)
            likeButton.addTarget(self, action: #selector(buttonDidClick(_:)), forControlEvents: .TouchUpInside)
            headerView.addSubview(likeButton)
            
            return headerView
            
        } else {
            return nil
        }

    }
    
    /**
     每组头视图高度方法
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return kViewMargin
            
        } else {
            return 0
        }
    }
    
}

extension DetailViewController: BaseStatusCellDelegate {
    
    /**
     由URL显示网页视图方法
     */
    func statusCellDidShowWebViewWithURL(cell: BaseStatusCell, url: NSURL) {
        
        let webVC = WebViewController(url: url)
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}
