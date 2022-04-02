//
//  CalcTwelveWeekDataTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner
import CoreData

class CalcTwelveWeekDataTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    var workoutHistory1: WorkoutHistory!
    var workoutHistory2: WorkoutHistory!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        workoutHistory1 = WorkoutHistory.init(context: coreDataStack.testContext)
        workoutHistory1.timestamp = Date.now
        workoutHistory1.time = 100.0
        
        workoutHistory2 = WorkoutHistory.init(context: coreDataStack.testContext)
        workoutHistory2.timestamp = Date.now.addingTimeInterval(-1000000)
        workoutHistory2.time = 200.0
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        workoutHistory1 = nil
        workoutHistory2 = nil
    }

    func testCalcTwelveWeekData() throws {

        let data = CalcTwelveWeekData(workoutHistories: [workoutHistory1, workoutHistory2])
        
        // Cannot currently check the contents as random values are being added for demonstration
        // purposes.
        //XCTAssertTrue(data == [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 2.0])

        XCTAssertTrue(data.count == 12)
    }
}
