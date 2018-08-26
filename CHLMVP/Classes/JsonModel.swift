//
//  JsonModel.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

// MARK: - define

public typealias JsonModel = Codable & JsonProtocol

public protocol JsonProtocol {
    static func decodeJson(data: Data?, decoder: JSONDecoder) throws -> Self
    func encodeToJson(encoder: JSONEncoder) throws -> Data
    func encodeToPropertyList(encoder: PropertyListEncoder) throws -> Data
}

public protocol MultipleContentProtocol: JsonModel {
    associatedtype SubModel: JsonModel
    var subModels: [SubModel] {get set}
}

// MARK: - implement
public extension JsonProtocol where Self: Codable {

    static func decodeJson(data: Data?, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        guard let data = data else {
            throw JsonConvertError.noDataError
        }
        return try decoder.decode(self, from: data)
    }

    func encodeToJson(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }

    func encodeToPropertyList(encoder: PropertyListEncoder = PropertyListEncoder()) throws -> Data {
        return try encoder.encode(self)
    }

}

public extension Data {

    func decodeToModel<T: JsonModel>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try T.decodeJson(data: self, decoder: decoder)
    }

    func decodePropertyListToModel<T: JsonModel>(type: T.Type, decoder: PropertyListDecoder = PropertyListDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }

}

extension Array: JsonProtocol where Element: JsonModel { }
