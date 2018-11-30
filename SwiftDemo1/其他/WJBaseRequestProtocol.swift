
//
//  WJBaseRequestProtocol.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ApiResult {
    
    case ok(message:AnyObject,state:Bool)
    case faild(message:String)
    case error(message:String)
    case empty
}
func goBlackLogoInViewController() -> ApiResult{
    let window = UIApplication.shared.keyWindow
//    let nav = WJNavgationController.init(rootViewController: WJLogoInController())
    let nav = UINavigationController.init(rootViewController: UIViewController())

    window?.rootViewController = nav
    window?.makeKeyAndVisible()
    UserDefaults.standard.removeObject(forKey: KMBASE_URL)
    return ApiResult.empty
}
