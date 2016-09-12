//
//  EmoticonKeyboardController.swift
//		CCWeiboAPP
//		Chen Chen @ September 11th, 2016
//

import UIKit

import Cartography

class EmoticonKeyboardController: UIViewController {

    // 表情包数组
    var packageArray: [EmoticonPackage] = EmoticonPackage.loadEmoticonPackageArray()
    
    // 表情组工具栏
    private lazy var emoticonBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.tintColor = StatusTabBarTextColor
        
        var itemArray = [UIBarButtonItem]()
        var index = 0
        for title in ["最近", "默认", "Emoji", "浪小花"] {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(itemButtonDidClick(_:)))
            item.tag = index
            index += 1
            itemArray.append(item)
            
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
            itemArray.append(flexibleItem)
        }
        
        itemArray.removeLast()
        toolbar.items = itemArray
        
        return toolbar
    }()
    
    // 表情键盘视图
    private lazy var emoticonView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonKeyboardLayout())
        collectionView.backgroundColor = ClearColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(EmoticonKeyboardCell.self, forCellWithReuseIdentifier: kEmoticonKeyboardReuseIdentifier)
        
        return collectionView
    }()
    
    // MARK: - 系统方法
    
    /**
     视图已经加载方法
     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        view.addSubview(emoticonView)
        view.addSubview(emoticonBar)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(emoticonView, emoticonBar) { (emoticonView, emoticonBar) in
            emoticonView.top == emoticonView.superview!.top
            emoticonView.bottom == emoticonBar.top
            
            emoticonBar.height == kNavigationBarHeight
            emoticonBar.bottom == emoticonBar.superview!.bottom
            
            align(left: emoticonView.superview!, emoticonView, emoticonBar)
            align(right: emoticonView.superview!, emoticonView, emoticonBar)
        }
    }
    
    /**
     组件按钮已经点击方法
     */
    @objc private func itemButtonDidClick(item: UIBarButtonItem) {

        for button in emoticonBar.items! {
            if button.tag == item.tag {
                button.tintColor = CommonDarkColor
                
            } else {
                button.tintColor = StatusTabBarTextColor
            }
        }
        
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }

}

extension EmoticonKeyboardController: UICollectionViewDataSource {
    
    /**
     共有组数方法
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return packageArray.count
    }
    
    /**
     每组集数方法
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packageArray[section].emoticonArray?.count ?? 0
    }
    
    /**
     每集内容方法
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kEmoticonKeyboardReuseIdentifier, forIndexPath: indexPath) as! EmoticonKeyboardCell
        let package = packageArray[indexPath.section]
        cell.emoticon = package.emoticonArray![indexPath.item]
        
        return cell
    }
    
}

extension EmoticonKeyboardController: UICollectionViewDelegate {
    
    /**
     选中集合方法
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let package = packageArray[indexPath.section]
        let emoticon = package.emoticonArray![indexPath.item]
        emoticon.count += 1
        if emoticon.isRemoveButton == false {
            packageArray[0].appendLastEmoticon(emoticon)
        }
    }
    
}

class EmoticonKeyboardLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let width = kScreenWidth / 7
        let height = collectionView!.bounds.height / 3
        itemSize = CGSize(width: width, height: height)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        scrollDirection = .Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
}