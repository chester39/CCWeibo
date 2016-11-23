//
//  PhotoPickerController.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 21st, 2016
//

import UIKit
import Photos

import Cartography
import TZImagePickerController

class PhotoPickerController: UIViewController {

    /// 照片数组
    var imageArray = [UIImage]()
    /// 已选照片数组
    fileprivate var assetArray = [PHAsset]()
    /// 最大图片数
    fileprivate let maxPhotoCount = 9
    /// Cell重用标识符
    fileprivate let reuseIdentifier = "PhotoPickerCell"
    
    /// 照片集合视图
    fileprivate lazy var photoView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoPickerLayout())
        collectionView.backgroundColor = RetweetStatusBackgroundColor
        collectionView.contentInset = UIEdgeInsets(top: kViewEdge, left: kViewEdge, bottom: kViewEdge, right: kViewEdge)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: - 初始化方法
    
    /**
     无参数初始化方法
     */
    init() {
        
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
        setupConstraints()
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        photoView.register(PhotoPickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(photoView)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(photoView) { photoView in
            photoView.edges == inset(photoView.superview!.edges, 0)
        }
    }
    
}

extension PhotoPickerController: UICollectionViewDataSource {
    
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
        
        return min(maxPhotoCount, imageArray.count + 1)
    }
    
    /**
     每集内容方法
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoPickerCell
        cell.delegate = self
        if indexPath.item < imageArray.count {
            cell.image = imageArray[indexPath.item]
        } else {
            cell.image = nil
        }
        
        return cell
    }
    
}

extension PhotoPickerController: PhotoPickerCellDelegate {
    
    /**
     图片按钮点击方法
     */
    func photoPickerCellImageButtonDidClick(cell: PhotoPickerCell) {
        
        let indexPath = photoView.indexPath(for: cell)!
        let ipc = TZImagePickerController(selectedAssets: NSMutableArray(array: assetArray), selectedPhotos: NSMutableArray(array: imageArray), index: indexPath.item)!
        ipc.allowPickingOriginalPhoto = false
        ipc.didFinishPickingPhotosHandle = { photos, assets, isSelectOriginalPhoto -> Void in
            self.imageArray = photos!
            self.assetArray = assets as! [PHAsset]
            self.photoView.reloadData()
        }
        
        present(ipc, animated: true, completion: nil)
    }
    
    /**
     添加按钮点击方法
     */
    func photoPickerCellAddButtonDidClick(cell: PhotoPickerCell) {
        
        let ipc = TZImagePickerController(maxImagesCount: maxPhotoCount, delegate: self)!
        ipc.sortAscendingByModificationDate = false
        ipc.allowPickingOriginalPhoto = false
        ipc.allowPickingVideo = false
        ipc.selectedAssets = NSMutableArray(array: assetArray)
        
        present(ipc, animated: true, completion: nil)
    }
    
    /**
     删除按钮点击方法
     */
    func photoPickerCellRemoveButtonDidClick(cell: PhotoPickerCell) {
        
        let indexPath = photoView.indexPath(for: cell)!
        imageArray.remove(at: indexPath.item)
        assetArray.remove(at: indexPath.item)
        photoView.reloadData()
    }
    
}

extension PhotoPickerController: TZImagePickerControllerDelegate {
    
    /**
     完成照片选择方法
     */
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        imageArray = photos
        assetArray = assets as! [PHAsset]
        photoView.reloadData()
    }
    
}

class PhotoPickerLayout: UICollectionViewFlowLayout {
    
    /**
     准备布局方法
     */
    override func prepare() {
        
        super.prepare()
        
        itemSize = CGSize(width: kViewStandard, height: kViewStandard)
        minimumInteritemSpacing = kViewPadding
        minimumLineSpacing = kViewPadding
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }

}
