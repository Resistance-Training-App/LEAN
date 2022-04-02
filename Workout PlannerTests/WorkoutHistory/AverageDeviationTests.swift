//
//  AverageDeviationTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class AverageDeviationTests: XCTestCase {
    
    var numbers: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        numbers = [1.0, 2.0, 3.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        numbers = []
    }

    func testAverageDeviation() throws {
        let averageDeviation = averageDeviation(numbers: numbers)

        XCTAssertTrue(averageDeviation == 66.66666666666667)
    }
    
    func testAverageDeviationEmpty() throws {
        let averageDeviation = averageDeviation(numbers: [])

        XCTAssertTrue(averageDeviation == 0.0)
    }
}
