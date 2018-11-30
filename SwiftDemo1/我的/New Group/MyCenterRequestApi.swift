//
//  MyCenterRequestApi.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
let  MyCenterRequestApiProvider = MoyaProvider<MyCenterRequestApi>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum MyCenterRequestApi {
    case centerRecordApiRequest(page:Int)                       //学习记录
   
}
extension MyCenterRequestApi : TargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: KMBASE_URL)!
        }
    }
    
    var path: String {
        switch self {
        case .centerRecordApiRequest:
            return "Apiq/study_record"
        }
    }
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {//"Content-Type" = "text/html; charset=UTF-8"
        switch self {
        default:
            return nil
        }
    }
    
    var task: Task {
        switch self {

        case .centerRecordApiRequest(let page):
            return .requestParameters(parameters: ["token": KMTOKEN,"p": page], encoding: URLEncoding.default)
        }
    }
}
