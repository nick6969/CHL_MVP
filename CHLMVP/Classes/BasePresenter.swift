//
//  BasePresenter.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

open class BasePresenter<Model>: ModelCacheProtocol where Model: JsonModel {
    public weak var loadDelegate: PresenterLoadDelegate?
    public weak var loadStateDelegate: PresenterLoadStateDelegate?
    public var status: PresenterState = .initialize
    public var usingCacheData: Bool = false

    public static var cacheKey: String {
        return "\(type(of: self))-ModelCacheKey"
    }

    public static func clearCache() {
        UserDefaults.standard.set(nil, forKey: cacheKey)
    }

    public var models: [Model] = [] {
        didSet {
            if models.isEmpty && status != .loadStart {
                DispatchQueue.main.async {
                    self.loadStateDelegate?.showEmptyView(with: nil)
                }
            }
        }
    }

    public var modelsSuccessClosure: (([Model]) -> Void)?
    public var modelSuccessClosure: ((Model) -> Void)?
    public var loadFailClosure: ((Error?) -> Void)?

    public var dataConvertToModelsClosure: ((Data) -> Void)?
    public var dataConvertToModelClosure: ((Data) -> Void)?

    public var cachedModelsSuccessClosure: (([Model]) -> Void)?

    public init() {
        setupClosure()
    }

    private func setupClosure() {
        dataConvertToModelsClosure = { [weak self] data in
            guard let `self` = self else { return }
            do {
                let models = try data.decodeToModel(type: [Model].self)
                self.modelsSuccessClosure?(models)
            } catch {
                self.loadFailClosure?(error)
            }
        }

        dataConvertToModelClosure = { [weak self] data in
            guard let `self` = self else { return }
            do {
                let model = try data.decodeToModel(type: Model.self)
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
                if self.usingCacheData {
                    type(of: self).cache(models: models)
                }
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
            if self.usingCacheData {
                type(of: self).cache(models: [model])
            }
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

        cachedModelsSuccessClosure = { [weak self] models in
            guard let `self` = self else { return }
            guard self.models.isEmpty else { return }
            let oldCount = 0
            let newCount = models.count
            self.models = models
            DispatchQueue.main.async {
                self.loadStateDelegate?.showLoading(false)
                self.loadStateDelegate?.removeEmptyView()
                self.loadDelegate?.loadingDone(oldCount, newCount)
            }
        }
    }

    public func loadCache() {
        guard usingCacheData else { return }
        if let models = type(of: self).getCacheModels() {
            self.cachedModelsSuccessClosure?(models)
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
