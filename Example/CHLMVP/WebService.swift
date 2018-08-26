//
//  WebService.swift
//  CHLMVP_Example
//
//  Created by Nick Lin on 2018/4/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

import Alamofire

typealias DataCompleClosure = (Data) -> Void
typealias LoadDataFailClosure = (Error?) -> Void

final class WebService: SessionManager {

    static let shared = WebService()
    private convenience init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        self.init(configuration: config, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
    }

    private func request(method: HTTPMethod, url: String = String(), parameters: [String: Any]? = nil, handle: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        request(url, method: method, parameters: parameters).validate().response { response in
            handle(response.data, response.response, response.error)
        }
    }

    private func baseRequest(method: HTTPMethod, url: String = String(), parameters: [String: Any]?, success: DataCompleClosure?, fail: LoadDataFailClosure?) {
        request(method: .get, url: url, parameters: parameters) { (data, res, error) in

            guard error == nil else {
                fail?(error)
                return
            }
            guard let datas = data else {
                fail?(nil)
                return
            }
            success?(datas)
            return
        }
    }

}

extension WebService {
    func getNewTaipeiChurchData(skip: Int, success: DataCompleClosure?, fail: LoadDataFailClosure?) {
        let url = "http://data.ntpc.gov.tw/od/data/api/8F29E30A-02B4-460B-B2E1-C1814163BBDE"
        var para: [String: Any] = [:]
        para["$top"] = 20
        para["$skip"] = skip
        para["$format"] = "json"
        baseRequest(method: .get, url: url, parameters: para, success: success, fail: fail)
    }
}
