//
//  FormatSecondsTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class FormatSecondsTests: XCTestCase {
    
    var time1: Int = 123
    var time2: Int = 3652

    func testFormatSecondsLessThan3600() throws {
        let formattedTime = formatSeconds(seconds: time1)

        XCTAssertTrue(formattedTime == "02:03")
    }
    
    func testFormatSecondsMoreThan3600() throws {
        let formattedTime = formatSeconds(seconds: time2)

        XCTAssertTrue(formattedTime == "01:00:52")
    }
}
