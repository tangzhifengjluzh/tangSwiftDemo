//
//  MyCenterRequestService.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import RxCocoa
import HandyJSON
class MyCenterRequestService{
    var recordArray:[Record] = [Record]()

    static let instance = MyCenterRequestService()
    
    func requestCenterApi(requestType:MyCenterRequestApi) -> Driver<ApiResult> {
        switch requestType {
        case .centerRecordApiRequest(let page):
            return centerRecordApiRequest(page:page)
//        default:
//            <#code#>
        }
    }
    //MARK: 我的学习记录
    private func centerRecordApiRequest(page:Int) -> Driver<ApiResult>{
        return MyCenterRequestApiProvider.rx.request(.centerRecordApiRequest(page: page)).filterSuccessfulStatusCodes().mapJSON().map({ (jsonObject) in
            let json:Dictionary = jsonObject as! Dictionary<String,AnyObject>
            let code:Int = json["ret_code"] as! Int
            let msg:String = json["msg"] as! String
            if code == 1 {
                let data = json["data"] as! Dictionary<String,AnyObject>
                let totle_page:Int = json["data"]!["totle_page"] as! Int
                let SignUptring = getJSONStringFromDictionary(dictionary: data as AnyObject)
                var model:Study_Record = Study_Record.deserialize(from: SignUptring)!
                if page == 1 {
                    self.recordArray = [Record]()
                }
                self.recordArray =  self.recordArray + model.list_data!
                model.list_data = self.recordArray
                if page == totle_page {
                    return ApiResult.ok(message: model as AnyObject, state: false)
                }else{
                    return ApiResult.ok(message: model as AnyObject, state: true)
                }
            }else if code == -1 {
                return goBlackLogoInViewController()
            }else{
                return ApiResult.faild(message: msg)
            }
        }).asDriver(onErrorJustReturn: ApiResult.error(message: "客官,您的网络不给力啊"))
    }
}
