//
//  IsTurningPointTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class IsTurningPointTests: XCTestCase {
    
    var data: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        data = [1.0, 2.0, 3.0, 1.0, 2.0, 3.0, 1.0, 2.0, 3.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        data = []
    }

    func testIsTurningPoint() throws {
        
        // Local maxima
        XCTAssertTrue(isTurningPoint(data: data, index: 2, scope: 1))
        XCTAssertTrue(isTurningPoint(data: data, index: 3, scope: 1))
        
        // Local minima
        XCTAssertFalse(isTurningPoint(data: data, index: 1, scope: 1))
        XCTAssertFalse(isTurningPoint(data: data, index: 4, scope: 1))
        
        XCTAssertTrue(isTurningPoint(data: data, index: 2, scope: 2))
    }
    
    func testIsTurningPointEmpty() throws {

        XCTAssertFalse(isTurningPoint(data: [], index: 1, scope: 1))
    }
}
