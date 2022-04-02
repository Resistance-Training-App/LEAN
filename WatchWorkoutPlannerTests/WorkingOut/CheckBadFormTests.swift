//
//  CheckBadFormTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class CheckBadFormTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    var profile: Profile!
    
    var showingAlert: Bool!
    var results1: [String]!
    var results2: [String]!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()

        profile = Profile.init(context: coreDataStack.testContext)
        
        showingAlert = false
        results1 = ["Other", "Other", "Other", "Good", "Good"]
        results2 = ["Other", "Other", "Other", "BadRange", "Good"]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        profile = nil
        showingAlert = nil
        results1 = nil
        results2 = nil
    }

    func testCheckBadForm() throws {
        var advice = checkBadForm(showingAlert: &showingAlert, profile: profile, results: results1)

        XCTAssertFalse(showingAlert)
        XCTAssertTrue(advice.isEmpty)

        advice = checkBadForm(showingAlert: &showingAlert, profile: profile, results: results2)

        XCTAssertTrue(showingAlert)
        XCTAssertFalse(advice.isEmpty)
    }
    
    func testCheckBadFormEmpty() throws {
        let advice = checkBadForm(showingAlert: &showingAlert, profile: profile, results: [])

        XCTAssertFalse(showingAlert)
        XCTAssertTrue(advice.isEmpty)
    }
}

