//
//  FindExercisingPercentageTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class FindExercisingPercentageTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testFindExercisingPercentage() throws {
        let percentage = findExercisingPercentage(results: ["Other", "Other", "Other", "Good", "Good",
                                                            "Good", "BadRange", "TooFast", "Other", "Other"])

        XCTAssertTrue(percentage == 50.0)
    }
    
    func testFindExercisingPercentageEmpty() throws {
        let percentage = findExercisingPercentage(results: [])

        XCTAssertTrue(percentage == 0.0)
    }
    
    func testFindExercisingPercentageOtherOnly() throws {
        let percentage = findExercisingPercentage(results: ["Other", "Other", "Other", "Other", "Other"])

        XCTAssertTrue(percentage == 0.0)
    }
}
