//
//  MovingAverageTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class MovingAverageTests: XCTestCase {
    
    var data: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        data = [1.0, 2.0, 3.0, 1.0, 2.0, 3.0, 1.0, 2.0, 3.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        data = []
    }

    func testMovingAverage() throws {
        let movingAverage = movingAverage(data: data, scope: 3)

        XCTAssertTrue(movingAverage == [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0])
    }
    
    func testMovingAverageNoScope() throws {
        let movingAverage = movingAverage(data: data, scope: 0)

        XCTAssertTrue(movingAverage == [])
    }
    
    func testMovingAverageEqual() throws {
        let movingAverage = movingAverage(data: [1.0], scope: 1)

        XCTAssertTrue(movingAverage == [1.0])
    }
    
    func testMovingAverageEmpty() throws {
        let movingAverage = movingAverage(data: [], scope: 1)

        XCTAssertTrue(movingAverage == [])
    }
}
