//
//  ShowDataPresenter.swift
//  CHLMVP_Example
//
//  Created by Nick Lin on 2018/4/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import CHLMVP

class ShowDataPresenter: BasePresenter<ChurchModel>, StandardPresenter {

    override init() {
        super.init()
        usingCacheData = true
    }
    
    func loadData() { loadWebData() }
    func loadDataMore() { loadWebData() }

    private func loadWebData() {
        WebService.shared.getNewTaipeiChurchData(skip: datasCount, success: dataConvertToModelsClosure, fail: loadFailClosure)
    }
}
