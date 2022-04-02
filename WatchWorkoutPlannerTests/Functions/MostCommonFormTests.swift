//
//  MostCommonFormTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class MostCommonFormTests: XCTestCase {

    var results: [String]!

    override func setUpWithError() throws {
        try super.setUpWithError()

        results = ["Other", "Other", "Other", "Good", "Good", "BadRange"]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        results = nil
    }

    func testMostCommonForm() throws {
        let form = mostCommonForm(formArray: results)

        XCTAssertTrue(form == "Good")
    }
    
    func testMostCommonFormEmpty() throws {
        let form = mostCommonForm(formArray: [])

        XCTAssertTrue(form == "N/A")
    }
}
