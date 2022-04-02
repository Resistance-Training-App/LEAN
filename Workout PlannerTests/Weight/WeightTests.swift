//
//  WeightTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class WeightTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var weight: Weight!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        weight = Weight.init(context: coreDataStack.testContext)
        weight.order = 0
        weight.count = 12
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        weight = nil
    }

    func testAddWeight() throws {
        XCTAssertNotNil(weight, "Weight should not be nil")
        XCTAssertTrue(weight.order == 0)
        XCTAssertTrue(weight.count == 12)
    }
}
