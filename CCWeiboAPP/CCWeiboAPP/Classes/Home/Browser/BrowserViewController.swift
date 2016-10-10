//
//	BrowserViewController.swift
//		CCWeiboAPP
//		Chen Chen @ September 2nd, 2016
//

import UIKit

import Cartography
import MBProgressHUD

class BrowserViewController: UIViewController {

    /// 微博配图中图URL数组
    var pictureURLArray: [NSURL]
    /// Cell索引
    var indexPath: NSIndexPath
    /// Cell重用标识符
    private let reuseIdentifier = "BrowserCell"
    
    /// 照片浏览视图
    private lazy var browserView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PictureLayout())
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    /// 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("关闭", forState: .Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CommonLightColor.CGColor
        button.setTitleColor(CommonLightColor, forState: .Normal)
        button.addTarget(self, action: #selector(closeButtonDidClick), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    /// 保存按钮
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", forState: .Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CommonLightColor.CGColor
        button.setTitleColor(CommonLightColor, forState: .Normal)
        button.addTarget(self, action: #selector(saveButtonDidClick), forControlEvents: .TouchUpInside)
        
        return button
    }()
    
    // MARK: - 初始化方法
    
    /**
     图片数组和索引初始化方法
     */
    init(urlArray: [NSURL], indexPath: NSIndexPath) {
        
        self.pictureURLArray = urlArray
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
        
        setupUI()
        setupConstraints()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    
    /**
     视图已经布局子视图方法
     */
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        browserView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        browserView.registerClass(BrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        browserView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(browserView)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(browserView) { (browserView) in
            browserView.edges == inset(browserView.superview!.edges, 0)
        }
        
        constrain(closeButton, saveButton) { (closeButton, saveButton) in
            closeButton.width == kViewStandard
            closeButton.height == kViewMargin
            closeButton.bottom == closeButton.superview!.bottom - kViewBorder
            closeButton.left == closeButton.superview!.left + kViewBorder
            
            saveButton.width == kViewStandard
            saveButton.height == kViewMargin
            saveButton.bottom == closeButton.bottom
            saveButton.right == saveButton.superview!.right - kViewBorder
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     关闭按钮点击方法
     */
    @objc private func closeButtonDidClick() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     保存按钮点击方法
     */
    @objc private func saveButtonDidClick() {
        
        let indexPath = browserView.indexPathsForVisibleItems().last!
        let cell = browserView.cellForItemAtIndexPath(indexPath) as! BrowserCell
        let image = cell.imageView.image!
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(BrowserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /**
     图片保存方法
     */
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: AnyObject?) {
        
        if error != nil {
            MBProgressHUD.showMessage("图片保存失败", delay: 1.0)
            return
        }
        
        MBProgressHUD.showMessage("图片保存成功", delay: 1.0)
    }
    
}

extension BrowserViewController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    /**
     每组集数方法
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureURLArray.count
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BrowserCell
        cell.imageURL = pictureURLArray[indexPath.item]
        
        return cell
    }

}