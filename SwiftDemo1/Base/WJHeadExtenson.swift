//
//  WJHeadExtenson.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import SDAutoLayout
import RxCocoa
import RxSwift
import Then
import RxDataSources
import SVProgressHUD
import SDWebImage
import MJRefresh
import Alamofire

let KMBASE_URL:String = "http://win2.qbt8.com/yjlx/Home/"
let disposeBag = DisposeBag()

var KMTOKEN:String {
    let str = "5ff40904c23b5759da3b1e159a84317c"
    
    UserDefaults.standard.set(str, forKey: KMBASE_URL)
    return UserDefaults.standard.object(forKey: KMBASE_URL) as! String
}
//字典转String
func getJSONStringFromDictionary(dictionary:AnyObject) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
}
