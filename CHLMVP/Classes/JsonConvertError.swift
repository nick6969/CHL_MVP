//
//  JsonConvertError.swift
//  CHLMVP
//
//  Created by Nick Lin on 2018/4/23.
//

import Foundation

public enum JsonConvertError: Error {
    case noDataError

    var localizedDescription: String {
        return "JSON Convert Error"
    }
}

extension JsonConvertError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noDataError: return "no Input Data"
        }
    }
}

extension JsonConvertError: CustomNSError {

    public static var errorDomain: String {
        return "JSON Convert Error"
    }

    public var errorCode: Int {
        switch self {
        case .noDataError: return 8000
        }
    }

    public var errorUserInfo: [String: Any] {
        switch self {
        case .noDataError: return [:]
        }
    }
}
