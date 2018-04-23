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
    static func decodeJson(data: Data?) throws -> Self
    func encodeToJson() throws -> Data
}

public protocol MultipleContentProtocol: JsonModel {
    associatedtype SubModel: JsonModel
    var subModels: [SubModel] {get set}
}

// MARK: - implement

public extension JsonProtocol where Self: Codable {

    static func decodeJson(data: Data?) throws -> Self {
        guard let data = data else {
            throw JsonConvertError.noDataError

        }
        do {
            return try JSONDecoder().decode(self, from: data)
        } catch {
            throw error
        }
    }

    func encodeToJson() throws -> Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            throw error
        }
    }

}

public extension Data {

    func decodeToModel<T: JsonModel>(type: T.Type) throws -> T {
        do {
            return try T.decodeJson(data: self)
        } catch {
            throw error
        }
    }

    func decodeToModelArray<T: JsonModel>(type: T.Type) throws -> [T] {
        do {
            return try JSONDecoder().decode([T].self, from: self)
        } catch {
            throw error
        }
    }

}
