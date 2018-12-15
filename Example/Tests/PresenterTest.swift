//
//  PresenterTest.swift
//  CHLMVP_Example
//
//  Created by Nick on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import CHLMVP

private struct TestModel: JsonModel {
    let name: String
    let age: Int
}

private class TestPresenter: BasePresenter<TestModel>, StandardPresenter {
    
    func loadData() { }
    
    func loadDataMore() { }
    
}

class PresenterTest: XCTestCase {
    
    private let json01 = "[{\"name\":\"nick\",\"age\":18},{\"name\":\"emma\",\"age\":16}]".data(using: .utf8)!
    
    private let json02 = "{\"name\":\"nick\",\"age\":18}".data(using: .utf8)!

    
    func testDataConvertToModelClosure() {
        let presenter = TestPresenter()
        presenter.nextState()
        presenter.dataConvertToModelClosure?(json02)
        XCTAssert(presenter.models.count == 1, "Convert fail")
        XCTAssert(presenter.models[0].name == "nick", "Data wrong")
        XCTAssert(presenter.models[0].age == 18, "Data wrong")
    }
    
    func testLoadStartConvertToModelsClosure() {
        let presenter = TestPresenter()
        presenter.nextState()
        presenter.dataConvertToModelsClosure?(json01)
        XCTAssert(presenter.models.count == 2, "Convert fail")
        XCTAssert(presenter.models[0].name == "nick", "Data wrong")
        XCTAssert(presenter.models[0].age == 18, "Data wrong")
        XCTAssert(presenter.models[1].name == "emma", "Data wrong")
        XCTAssert(presenter.models[1].age == 16, "Data wrong")
    }
    
    func testLoadFailConvertToModelsClosure() {
        let presenter = TestPresenter()
        presenter.status = .loadFail
        presenter.nextState()
        presenter.dataConvertToModelsClosure?(json01)
        XCTAssert(presenter.models.count == 2, "Convert fail")
        XCTAssert(presenter.models[0].name == "nick", "Data wrong")
        XCTAssert(presenter.models[0].age == 18, "Data wrong")
        XCTAssert(presenter.models[1].name == "emma", "Data wrong")
        XCTAssert(presenter.models[1].age == 16, "Data wrong")
    }
    
    func testLoadMoreStartConvertToModelsClosure() {
        let presenter = TestPresenter()
        presenter.status = .loadStart
        presenter.dataConvertToModelsClosure?(json01)
        presenter.status = .loadDone
        presenter.nextState()
        presenter.dataConvertToModelsClosure?(json01)
        XCTAssert(presenter.models.count == 4, "Convert fail")
        XCTAssert(presenter.models[0].name == "nick", "Data wrong")
        XCTAssert(presenter.models[0].age == 18, "Data wrong")
        XCTAssert(presenter.models[1].name == "emma", "Data wrong")
        XCTAssert(presenter.models[1].age == 16, "Data wrong")
        XCTAssert(presenter.models[2].name == "nick", "Data wrong")
        XCTAssert(presenter.models[2].age == 18, "Data wrong")
        XCTAssert(presenter.models[3].name == "emma", "Data wrong")
        XCTAssert(presenter.models[3].age == 16, "Data wrong")
    }
    
    func testLoadMoreFailConvertToModelsClosure() {
        let presenter = TestPresenter()
        presenter.status = .loadStart
        presenter.dataConvertToModelsClosure?(json01)
        presenter.status = .loadMoreStart
        presenter.dataConvertToModelsClosure?(json01)
        presenter.status = .loadMoreFail
        presenter.nextState()
        presenter.dataConvertToModelsClosure?(json01)
        XCTAssert(presenter.models.count == 6, "Convert fail")
        XCTAssert(presenter.models[0].name == "nick", "Data wrong")
        XCTAssert(presenter.models[0].age == 18, "Data wrong")
        XCTAssert(presenter.models[1].name == "emma", "Data wrong")
        XCTAssert(presenter.models[1].age == 16, "Data wrong")
        XCTAssert(presenter.models[2].name == "nick", "Data wrong")
        XCTAssert(presenter.models[2].age == 18, "Data wrong")
        XCTAssert(presenter.models[3].name == "emma", "Data wrong")
        XCTAssert(presenter.models[3].age == 16, "Data wrong")
        XCTAssert(presenter.models[4].name == "nick", "Data wrong")
        XCTAssert(presenter.models[4].age == 18, "Data wrong")
        XCTAssert(presenter.models[5].name == "emma", "Data wrong")
        XCTAssert(presenter.models[5].age == 16, "Data wrong")
    }
    
    func testLoadFailClosure() {
        let presenter = TestPresenter()
        
        presenter.status = .loadStart
        presenter.loadFailClosure?(nil)
        XCTAssert(presenter.status == .loadFail, "state wrong")
        
        presenter.status = .loadFail
        presenter.loadFailClosure?(nil)
        XCTAssert(presenter.status == .loadFail, "state wrong")
        
        presenter.status = .loadMoreStart
        presenter.loadFailClosure?(nil)
        XCTAssert(presenter.status == .loadMoreFail, "state wrong")
    }
}
