//
//  FindUniqueFormTypesTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class FindUniqueFormTypesTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    var metrics1: Metrics!
    var metrics2: Metrics!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        metrics1 = Metrics.init(context: coreDataStack.testContext)
        metrics1.results = ["Good", "Good", "Good", "Other"]
        
        metrics2 = Metrics.init(context: coreDataStack.testContext)
        metrics1.results = ["Good", "BadRange", "Good", "Other"]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        metrics1 = nil
        metrics2 = nil
    }

    func testFindUniqueFormTypes() throws {
        let formTypes = findUniqueFormTypes(metrics: [metrics1, metrics2])

        XCTAssertTrue(formTypes == ["Good", "Other", "BadRange"])
    }
    
    func testFindUniqueFormTypesEmpty() throws {
        let formTypes = findUniqueFormTypes(metrics: [])
        print(formTypes)
        XCTAssertTrue(formTypes == [])
    }
}
