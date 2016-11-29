//
//  ProfileGroup.swift
//      CCWeiboSwiftApp
//		Chen Chen @ November 29th, 2016
//

import UIKit

class ProfileGroup: NSObject {

    /// 选项组名
    var group: String?
    /// 选项组内容
    var detail = [ProfileModel]()
    
    // MARK: - 初始化方法
    
    /**
     字典初始化方法
     */
    init(dict: [String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
    }
    
    /**
     默认KVC方法
     */
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "detail" {
            var array = [ProfileModel]()
            for dict in value as! [[String: Any]] {
                let profile = ProfileModel(dict: dict)
                array.append(profile)
            }
            
            detail = array
            return
        }
        
        super.setValue(value, forKey: key)
    }

}
