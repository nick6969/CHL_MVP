//
//  ModelCacheProtocol.swift
//  Alamofire
//
//  Created by Nick Lin on 2018/9/5.
//

import Foundation

public protocol ModelCacheProtocol {
    associatedtype Model: JsonModel
    var models: [Model] { get set }
    static var cacheKey: String { get }
    static func getCacheModels() -> [Model]?
    static func cache(models: [Model])
    static func clearCache()
}

public extension ModelCacheProtocol {

    static var cacheKey: String {
        return "\(type(of: self))-ModelCacheKey"
    }

    static func clearCache() {
        UserDefaults.standard.set(nil, forKey: cacheKey)
    }

    static func getCacheModels() -> [Model]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        guard let value = try? data.decodePropertyListToModel(type: [Model].self) else { return nil }
        return value
    }

    static func cache(models: [Model]) {
        guard let data = try? models.encodeToPropertyList() else { return }
        UserDefaults.standard.set(data, forKey: cacheKey)
        UserDefaults.standard.synchronize()
    }
}
