//
//  CalcAverageRepTimesTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class CalcAverageRepTimesTests: XCTestCase {
    
    var repStartTimes: [Double]!
    var repEndTimes: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        repStartTimes = [1.0, 2.0, 3.0]
        repEndTimes = [2.0, 3.0, 4.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        repStartTimes = []
        repEndTimes = []
    }

    func testCalcAverageRepTimes() throws {
        let averageTime = calcAverageRepTime(repStartTimes: repStartTimes,
                                             repEndTimes: repEndTimes)

        XCTAssertTrue(averageTime == 1.0)
    }
    
    func testCalcAverageRepTimesEmpty() throws {
        let averageTime = calcAverageRepTime(repStartTimes: [],
                                             repEndTimes: [])

        XCTAssertTrue(averageTime == 0.0)
    }
    
    func testCalcAverageRepTimesNotEqualLength() throws {
        let averageTime = calcAverageRepTime(repStartTimes: repStartTimes,
                                             repEndTimes: Array(repEndTimes[1...2]))

        XCTAssertTrue(averageTime == 2.0)
    }
}
