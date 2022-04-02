//
//  CalcEccentricConcentricRatioTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class CalcEccentricConcentricRatioTests: XCTestCase {
    
    var repStartTimes: [Double]!
    var repMiddleTimes: [Double]!
    var repEndTimes: [Double]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        repStartTimes = [1.0, 3.0, 5.0]
        repMiddleTimes = [2.0, 4.0, 6.0]
        repEndTimes = [3.0, 5.0, 7.0]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        repStartTimes = []
        repMiddleTimes = []
        repEndTimes = []
    }

    func testCalcEccentricConcentricRatio() throws {
        let eccentricRatio = calcEccentricConcentricRatio(repStartTimes: repStartTimes,
                                                          repMiddleTimes: repMiddleTimes,
                                                          repEndTimes: repEndTimes,
                                                          isEccentric: true)
        
        let concentricRatio = calcEccentricConcentricRatio(repStartTimes: repStartTimes,
                                                          repMiddleTimes: repMiddleTimes,
                                                          repEndTimes: repEndTimes,
                                                          isEccentric: false)

        XCTAssertTrue(eccentricRatio == 50.0)
        XCTAssertTrue(concentricRatio == 50.0)
        XCTAssertTrue(eccentricRatio + concentricRatio == 100.0)
    }
    
    func testCalcEccentricConcentricRatioEmpty() throws {
        let eccentricRatio = calcEccentricConcentricRatio(repStartTimes: [],
                                                          repMiddleTimes: [],
                                                          repEndTimes: [],
                                                          isEccentric: true)
        
        let concentricRatio = calcEccentricConcentricRatio(repStartTimes: [],
                                                          repMiddleTimes: [],
                                                          repEndTimes: [],
                                                          isEccentric: false)

        XCTAssertTrue(eccentricRatio == 0.0)
        XCTAssertTrue(concentricRatio == 0.0)
        XCTAssertTrue(eccentricRatio + concentricRatio == 0.0)
    }
}
