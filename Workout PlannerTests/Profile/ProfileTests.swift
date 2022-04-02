//
//  ProfileTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class ProfileTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
    }
    
    // Checking that when 'loadProfile' is loaded twice, a duplicate profile object is not created.
    func testLoadProfile() throws {
        _ = loadProfile(viewContext: coreDataStack.testContext)
        
        var profiles = try coreDataStack.testContext.fetch(Profile.fetchRequest())
        
        XCTAssertTrue(profiles.count == 1)
        
        _ = loadProfile(viewContext: coreDataStack.testContext)
        
        profiles = try coreDataStack.testContext.fetch(Profile.fetchRequest())
        
        XCTAssertTrue(profiles.count == 1)
    }
}
