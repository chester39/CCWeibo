//
//	PictureBrowserController.swift
//		CCWeiboAPP
//		Chen Chen @ September 2nd, 2016
//

import UIKit

import Cartography

class PictureBrowserController: UIViewController {

    // 微博配图中图URL数组
    var pictureURLArray: [NSURL]
    // Cell索引
    var indexPath: NSIndexPath
    
    // 照片浏览视图
    private lazy var browserView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PictureLayout())
        collectionView.dataSource = self
        collectionView.registerClass(PictureBrowserCell.self, forCellWithReuseIdentifier: kPictureBrowserReuseIdentifier)
        
        return collectionView
    }()
    
    // 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("关闭", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(closeButtonDidClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    // 保存按钮
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", forState: UIControlState.Normal)
//        button.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(saveButtonDidClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
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
        
        browserView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
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
            closeButton.width == 100
            closeButton.height == 40
            closeButton.bottom == closeButton.superview!.bottom - kViewMargin
            closeButton.left == closeButton.superview!.left + kViewMargin
            
            saveButton.width == 100
            saveButton.height == 40
            saveButton.bottom == closeButton.bottom
            saveButton.right == saveButton.superview!.right - kViewMargin
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
        
        print(#function)
    }
    
}

extension PictureBrowserController: UICollectionViewDataSource {
    
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPictureBrowserReuseIdentifier, forIndexPath: indexPath) as! PictureBrowserCell
        cell.imageURL = pictureURLArray[indexPath.item]
        
        return cell
    }

}
