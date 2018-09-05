//
//  Presenter.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

// MARK: - define

public typealias StandardPresenter = PresenterDataProtocol & PresenterLoadProtocol & PresenterLoadFuncProtocol
public typealias StandardMultipleContentPresenter = MultipleContentDataProtocol & PresenterLoadProtocol & PresenterLoadFuncProtocol

public protocol PresenterLoadDelegate: class {
    func loadingDone(_ oldCount: Int, _ newCount: Int)
    func loadingFail(_ error: Error?)
}

public protocol PresenterLoadStateDelegate: class {
    func showEmptyView(with: Error?)
    func removeEmptyView()
    func showLoading(_ bool: Bool)
}

public protocol PresenterLoadProtocol: class {
    var loadDelegate: PresenterLoadDelegate? {get set}
    var loadStateDelegate: PresenterLoadStateDelegate? {get set}
    var status: PresenterState { get set }
    func refreshData()
    func nextState()
}

public protocol PresenterLoadFuncProtocol: class {
    func loadCache()
    func loadData()
    func loadDataMore()
}

// MARK: - implement

public extension PresenterLoadProtocol where Self: BaseDataProtocol, Self: PresenterLoadFuncProtocol {

    func refreshData() {
        if status != .loadStart {
            status = .refreshLoading
            nextState()
        }
    }

    func nextState() {
        switch status {
        case .initialize:
            status = .loadCacheStart
            loadCache()
            nextState()

        case .loadCacheStart, .loadFail:
            status = .loadStart
            if models.isEmpty {
                DispatchQueue.main.async {
                    self.loadStateDelegate?.showLoading(true)
                }
            }
            loadData()

        case .loadDone, .loadMoreDone, .loadMoreFail:
            status = .loadMoreStart
            loadDataMore()

        case .refreshLoading:
            status = .loadStart
            models = []
            DispatchQueue.main.async {
                self.loadStateDelegate?.showLoading(true)
            }
            loadData()

        case .loadStart, .loadMoreStart, .noMoreCanLoad:
            break
        }
    }

}
