//
//  PhotoPickerCell.swift
//		CCWeiboAPP
//		Chen Chen @ September 17th, 2016
//

import UIKit

import Cartography

@objc protocol PhotoPickerCellDelegate: NSObjectProtocol {
    
    /**
     图片按钮点击方法
     */
    optional func photoPickerCellImageButtonDidClick(cell: PhotoPickerCell)
    /**
     添加按钮点击方法
     */
    optional func photoPickerCellAddButtonDidClick(cell: PhotoPickerCell)
    /**
     删除按钮点击方法
     */
    optional func photoPickerCellRemoveButtonDidClick(cell: PhotoPickerCell)
    
}

class PhotoPickerCell: UICollectionViewCell {
    
    /// 图片按钮
    private var imageButton = UIButton(imageName: nil, backgroundImageName: "compose_pic_add")
    /// 删除按钮
    private var removeButton = UIButton(type: .Custom)
    /// PhotoPickerCellDelegate代理
    weak var delegate: PhotoPickerCellDelegate?
    
    /// 选中图片
    var image: UIImage? {
        didSet {
            removeExistingImageView()
            if image == nil {
                removeButton.hidden = true
                imageButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                imageButton.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
                
            } else {
                removeButton.hidden = false
                imageButton.setBackgroundImage(image, forState: .Normal)
                imageButton.contentMode = .ScaleAspectFill
                imageButton.clipsToBounds = true
            }
        }
    }
    
    // MARK: - 初始化方法
    
    /**
     自定义初始化方法
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    /**
     数据解码XIB初始化方法
     */
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 界面方法
    
    /**
     初始化界面方法
     */
    private func setupUI() {
        
        imageButton.addTarget(self, action: #selector(imageButtonDidClick), forControlEvents: .TouchUpInside)
        addSubview(imageButton)
        
        removeButton.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        removeButton.hidden = true
        removeButton.addTarget(self, action: #selector(removeButtonDidClick), forControlEvents: .TouchUpInside)
        addSubview(removeButton)
    }
    
    /**
     初始化约束方法
     */
    private func setupConstraints() {
        
        constrain(imageButton, removeButton) { (imageButton, removeButton) in
            imageButton.edges == inset(imageButton.superview!.edges, 0)
            
            removeButton.width == kViewBorder
            removeButton.height == kViewBorder
            removeButton.top == removeButton.superview!.top
            removeButton.right == removeButton.superview!.right
        }
    }
    
    /**
     删除已存在图片视图方法
     */
    private func removeExistingImageView() {
        
        for view in subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK: - 按钮方法
    
    /**
     图片按钮点击方法
     */
    @objc private func imageButtonDidClick() {
        
        if let tempDelegate = delegate {
            if image == nil {
                if tempDelegate.respondsToSelector(#selector(PhotoPickerCellDelegate.photoPickerCellAddButtonDidClick(_:))) {
                    tempDelegate.photoPickerCellAddButtonDidClick!(self)
                }
                
            } else {
                if tempDelegate.respondsToSelector(#selector(PhotoPickerCellDelegate.photoPickerCellImageButtonDidClick(_:))) {
                    tempDelegate.photoPickerCellImageButtonDidClick!(self)
                }
            }
        }
    }
    
    /**
     删除按钮点击方法
     */
    @objc private func removeButtonDidClick() {
        
        if let tempDelegate = delegate {
            if tempDelegate.respondsToSelector(#selector(PhotoPickerCellDelegate.photoPickerCellRemoveButtonDidClick(_:))) {
                tempDelegate.photoPickerCellRemoveButtonDidClick!(self)
            }
        }
    }
    
}
