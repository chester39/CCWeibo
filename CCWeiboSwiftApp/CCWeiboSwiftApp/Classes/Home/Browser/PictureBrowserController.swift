//
//  PictureBrowserController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 23rd, 2016
//

import UIKit

import Cartography
import MBProgressHUD

class PictureBrowserController: UIViewController {

    /// 微博配图中图URL数组
    var pictureURLArray: [URL]
    /// Cell索引
    var indexPath: IndexPath
    /// Cell重用标识符
    fileprivate let reuseIdentifier = "BrowserCell"
    
    /// 照片浏览视图
    private lazy var browserView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PictureBrowserLayout())
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    /// 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = kViewEdge
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = kCommonLightColor.cgColor
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(kCommonLightColor, for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        
        return button
    }()
    
    /// 保存按钮
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", for: .normal)
        button.layer.cornerRadius = kViewEdge
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = kCommonLightColor.cgColor
        button.setTitleColor(kCommonLightColor, for: .normal)
        button.addTarget(self, action: #selector(saveButtonDidClick), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 初始化方法
    
    /**
     图片数组和索引初始化方法
     */
    init(urlArray: [URL], indexPath: IndexPath) {
        
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
        
        browserView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        browserView.register(PictureBrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        
        constrain(browserView) { browserView in
            browserView.edges == inset(browserView.superview!.edges, 0)
        }
        
        constrain(closeButton, saveButton) { closeButton, saveButton in
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
        
        dismiss(animated: true, completion: nil)
    }
    
    /**
     保存按钮点击方法
     */
    @objc private func saveButtonDidClick() {
        
        let indexPath = browserView.indexPathsForVisibleItems.last
        let cell = browserView.cellForItem(at: indexPath!) as! PictureBrowserCell
        let image = cell.imageView.image!
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PictureBrowserController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /**
     图片保存方法
     */
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: AnyObject?) {
        
        if error != nil {
            MBProgressHUD.showMessage(text: "图片保存失败", delay: 1.0)
            return
        }
        
        MBProgressHUD.showMessage(text: "图片保存成功", delay: 1.0)
    }
    
}

extension PictureBrowserController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    /**
     每组集数方法
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureURLArray.count
    }
    
    /**
     每集内容方法
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PictureBrowserCell
        cell.imageURL = pictureURLArray[indexPath.item]
        
        return cell
    }

}

class PictureBrowserLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepare() {
        
        super.prepare()
        
        itemSize = kScreenFrame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}
