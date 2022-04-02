//
//  StretchingTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class StretchingTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    var stretch: Stretch!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        stretch = Stretch.init(context: coreDataStack.testContext)
        stretch.category = Category.upperBody.rawValue
        stretch.id = UUID()
        stretch.isCopy = false
        stretch.name = "Cross-Body Shoulder Stretch"
        stretch.order = 0
        stretch.picture = Data.init()
        stretch.repTime = 20
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        stretch = nil
    }

    func testAddStretch() throws {
        XCTAssertNotNil(stretch, "Stretch should not be nil")
        XCTAssertTrue(stretch.category == Category.upperBody.rawValue)
        XCTAssertTrue(stretch.isCopy == false)
        XCTAssertTrue(stretch.name == "Cross-Body Shoulder Stretch")
        XCTAssertTrue(stretch.order == 0)
        XCTAssertTrue(stretch.repTime == 20)
    }
    
    func testDeleteStretch() throws {
        coreDataStack.testContext.delete(stretch)
        do { try coreDataStack.testContext.save() } catch {
            print(error.localizedDescription)
        }

        XCTAssertNil(stretch.name)
    }
}
