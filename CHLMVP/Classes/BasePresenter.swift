//
//  BasePresenter.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

open class BasePresenter<T> where T: JsonModel {
    public weak var loadDelegate: PresenterLoadDelegate?
    public weak var loadStateDelegate: PresenterLoadStateDelegate?
    public var status: PresenterState = .initialize

    public var models: [T] = [] {
        didSet {
            if models.isEmpty && status != .loadStart {
                DispatchQueue.main.async {
                    self.loadStateDelegate?.showEmptyView(with: nil)
                }
            }
        }
    }

    public var modelsSuccessClosure: (([T]) -> Void)?
    public var modelSuccessClosure: ((T) -> Void)?
    public var loadFailClosure: ((Error?) -> Void)?

    public var dataConvertToModelsClosure: ((Data) -> Void)?
    public var dataConvertToModelClosure: ((Data) -> Void)?

    public init() {
        setupClosure()
    }

    private func setupClosure() {
        dataConvertToModelsClosure = { [weak self] data in
            guard let `self` = self else { return }
            do {
                let models = try data.decodeToModel(type: [T].self)
                self.modelsSuccessClosure?(models)
            } catch {
                self.loadFailClosure?(error)
            }
        }

        dataConvertToModelClosure = { [weak self] data in
            guard let `self` = self else { return }
            do {
                let model = try data.decodeToModel(type: T.self)
                self.modelSuccessClosure?(model)
            } catch {
                self.loadFailClosure?(error)
            }
        }

        modelsSuccessClosure = { [weak self] models in
            guard let `self` = self else { return }
            var oldCount = self.models.count
            var newCount = self.models.count
            if self.status == .loadStart {
                oldCount = 0
                newCount = models.count
                self.models = models
            } else if self.status == .loadMoreStart {
                if models.isEmpty {
                    self.status = .noMoreCanLoad
                } else {
                    self.models.append(contentsOf: models)
                    newCount = self.models.count
                }
            }
            self.loadDoneChangeState()
            DispatchQueue.main.async {
                self.loadStateDelegate?.showLoading(false)
                if self.models.isEmpty {
                    self.loadStateDelegate?.showEmptyView(with: nil)
                } else {
                    self.loadStateDelegate?.removeEmptyView()
                }
                self.loadDelegate?.loadingDone(oldCount, newCount)
            }
        }

        modelSuccessClosure = { [weak self] model in
            guard let `self` = self else { return }
            self.models = [model]
            self.loadDoneChangeState()
            DispatchQueue.main.async {
                self.loadStateDelegate?.showLoading(false)
                self.loadStateDelegate?.removeEmptyView()
                self.loadDelegate?.loadingDone(0, 1)
            }
        }

        loadFailClosure = { [weak self] error in
            guard let `self` = self else { return }
            self.loadFailChangeState()
            DispatchQueue.main.async {
                self.loadStateDelegate?.showLoading(false)
                if self.models.isEmpty {
                    self.loadStateDelegate?.showEmptyView(with: error)
                }
                self.loadDelegate?.loadingFail(error)
            }
        }
    }

    private func loadDoneChangeState() {
        switch status {
        case .loadStart:
            status = .loadDone
        case .loadMoreStart:
            status = .loadMoreDone
        default:
            break
        }
    }

    private func loadFailChangeState() {
        switch status {
        case .loadStart:
            status = .loadFail
        case .loadMoreStart:
            status = .loadMoreFail
        default:
            break
        }
    }
}
