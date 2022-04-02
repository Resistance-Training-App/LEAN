//
//  StartWorkoutTests.swift
//  WatchWorkoutPlannerTests
//

import XCTest
@testable import WatchWorkoutPlanner_Extension

class StartWorkoutTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    var workout: Workout!
    
    var workoutManager: WorkoutManager!

    var motionManager: MotionManager!

    override func setUpWithError() throws {

        coreDataStack = TestCoreDataStack()

        workout = Workout.init(context: coreDataStack.testContext)
        workout.addToExercises(Exercise.init(context: coreDataStack.testContext))
    
        workoutManager = WorkoutManager.init()
        workoutManager.myWorkout = workout

        motionManager = MotionManager.init()
    }

    override func tearDownWithError() throws {
        workout = nil
        workoutManager = nil
        motionManager = nil
    }

    func testStartWorkout() throws {
        startWorkout(workout: workoutManager, motion: motionManager)
        
        XCTAssertTrue(workoutManager.showingWorkoutHome)
        XCTAssertFalse(workoutManager.showingStretchingHome)
        XCTAssertNotNil(workoutManager.session)
        XCTAssertNotNil(workoutManager.builder)
        XCTAssertTrue(workoutManager.preWorkoutCountdown.mode == .stopped)
    }
}
