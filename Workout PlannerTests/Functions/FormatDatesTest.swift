//
//  FormatDatesTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class FormatDatesTests: XCTestCase {
    
    var date1: Date = Date.init(timeIntervalSinceReferenceDate: 0)
    var date2: Date = Date.init(timeIntervalSinceReferenceDate: 1000000000000)

    func testFormatDatePast() throws {
        let formattedDate = formatDate(date: date1)

        XCTAssertTrue(formattedDate == "01/01/2001")
    }
    
    func testFormatDataFuture() throws {
        let formattedDate = formatDate(date: date2)

        XCTAssertTrue(formattedDate == "Tuesday")
    }
}
