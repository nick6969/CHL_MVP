//
//  PresenterState.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

public enum PresenterState {
    case initialize
    case loadCacheStart
    case loadStart
    case loadDone
    case loadFail
    case loadMoreStart
    case loadMoreDone
    case loadMoreFail
    case noMoreCanLoad
    case refreshLoading
}
