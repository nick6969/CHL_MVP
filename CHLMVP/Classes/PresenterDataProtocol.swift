//
//  PresenterDataProtocol.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

// MARK: - define

public protocol BaseDataProtocol: class {
    associatedtype Model
    var models: [Model] { get set }
}

public protocol PresenterDataProtocol: BaseDataProtocol where Model: JsonModel {
    var datasCount: Int { get }
    func model(at index: Int) -> Model?
    func isLastData(index: Int) -> Bool
    func isLoadMore(index: Int) -> Bool
}

public protocol MultipleContentDataProtocol: BaseDataProtocol where Model: MultipleContentProtocol {
    func numberOfSection() -> Int
    func numberOfItem(in section: Int) -> Int
    func modelAt(section: Int) -> Model?
    func modelAt(indexPath: IndexPath) -> Model.SubModel?
    func isLastData(index: IndexPath) -> Bool
}

// MARK: - implement

public extension Array {
    fileprivate subscript(safe index: Int) -> Element? {
        return (0 <= index && index < count) ? self[index] : nil
    }
}

public extension PresenterDataProtocol {

    var datasCount: Int {
        return models.count
    }

    func model(at index: Int) -> Model? {
        return models[safe: index]
    }

    func isLastData(index: Int) -> Bool {
        return index + 1 == datasCount
    }

    func isLoadMore(index: Int) -> Bool {
        if models.isEmpty { return false }
        return index == datasCount
    }

}

public extension MultipleContentDataProtocol {

    func numberOfSection() -> Int {
        return models.count
    }

    func numberOfItem(in section: Int) -> Int {
        return modelAt(section: section)?.subModels.count ?? 0
    }

    func modelAt(section: Int) -> Model? {
        return models[safe: section]
    }

    func modelAt(indexPath: IndexPath) -> Model.SubModel? {
        return models[safe: indexPath.section]?.subModels[safe: indexPath.item]
    }

    func isLastData(index: IndexPath) -> Bool {
        return index.section + 1 == models.count && index.item + 1 == numberOfItem(in: index.section)
    }

}
