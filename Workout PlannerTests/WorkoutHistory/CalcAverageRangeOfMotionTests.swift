//
//  CalcAverageRangeOfMotionTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class CalcAverageRangeOfMotionTests: XCTestCase {
    
    var repRangeOfMotions: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        repRangeOfMotions = [1.0, 2.0, 3.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        repRangeOfMotions = []
    }

    func testCalcAverageRangeOfMotion() throws {
        let averageRangeOfMotion = calcAverageRangeOfMotion(repRangeOfMotions: repRangeOfMotions)

        XCTAssertTrue(averageRangeOfMotion == 2.0)
    }
    
    func testCalcAverageRangeOfMotionEmpty() throws {
        let averageRangeOfMotion = calcAverageRangeOfMotion(repRangeOfMotions: [])

        XCTAssertTrue(averageRangeOfMotion == 0.0)
    }
}
