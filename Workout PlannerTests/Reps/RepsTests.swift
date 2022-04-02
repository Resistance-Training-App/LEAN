//
//  RepsTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class RepsTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var reps: Reps!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        reps = Reps.init(context: coreDataStack.testContext)
        reps.order = 0
        reps.count = 10
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        reps = nil
    }

    func testAddReps() throws {
        XCTAssertNotNil(reps, "Reps should not be nil")
        XCTAssertTrue(reps.order == 0)
        XCTAssertTrue(reps.count == 10)
    }
}
