//
//  WJMySelfRecordViewModel.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/28.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import HandyJSON



struct Record : HandyJSON {
    var id:String?
    var picture:String = ""
    var video_url:String = ""
    var intro:String = ""
    var create_time:String?
    var nick_name:String?
    var own:String?
    var user_id:String?
    var look_count:String?
    var rank:String?
    var images:String?
}

struct Study_Record : HandyJSON {
    var rank:String?
    var study_day:String?
    var study_count:String?
    var list_data:[Record]?
}
class WJMySelfRecordViewModel {
    var page = Variable<Int>(1)
    var refreshTap = Variable<Bool>(true)
    var recordObservable:Observable<ApiResult>
    
    init(){
        let service = MyCenterRequestService.instance
        
        recordObservable = refreshTap.asObservable().withLatestFrom(page.asObservable()).flatMapLatest({ (page)  in
            return service.requestCenterApi(requestType: .centerRecordApiRequest(page: page)).asObservable()
        }).share(replay: 1, scope: .whileConnected)
    }
    
}

