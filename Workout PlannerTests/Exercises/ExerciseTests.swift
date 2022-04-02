//
//  ExerciseTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class ExerciseTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var weight_1: Weight!
    var weight_2: Weight!

    var reps_1: Reps!
    var reps_2: Reps!

    var exercise: Exercise!

    override func setUpWithError() throws {
        try super.setUpWithError()

        coreDataStack = TestCoreDataStack()
        
        weight_1 = Weight.init(context: coreDataStack.testContext)
        weight_1.order = 0; weight_1.count = 12
        weight_2 = Weight.init(context: coreDataStack.testContext)
        weight_2.order = 1; weight_2.count = 10
        
        reps_1 = Reps.init(context: coreDataStack.testContext)
        reps_1.order = 0; reps_1.count = 20
        reps_2 = Reps.init(context: coreDataStack.testContext)
        reps_2.order = 1; reps_2.count = 15
        
        exercise = Exercise.init(context: coreDataStack.testContext)
        exercise.order = 0
        exercise.name = "Bicep Curl"
        exercise.repTime = 3
        exercise.desc = "Bicep curl description."
        exercise.tutorial = "https://www.youtube.com/watch?v=ykJmrZ5v0Oo"
        exercise.isFavourite = false
        exercise.isHold = false
        exercise.userCreated = false
        exercise.picture = Data.init()
        exercise.category = Category.upperBody.rawValue
        exercise.equipment = Equipment.dumbbells.rawValue
        exercise.weight = NSSet.init(array: [weight_1!, weight_2!])
        exercise.reps = NSSet.init(array: [reps_1!, reps_2!])
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        weight_1 = nil
        weight_2 = nil
        reps_1 = nil
        reps_2 = nil
        exercise = nil
    }

    func testAddExercise() throws {
        XCTAssertNotNil(exercise, "Exercise should not be nil")
        XCTAssertTrue(exercise.order == 0)
        XCTAssertTrue(exercise.name == "Bicep Curl")
        XCTAssertTrue(exercise.repTime == 3)
        XCTAssertTrue(exercise.desc == "Bicep curl description.")
        XCTAssertTrue(exercise.tutorial == "https://www.youtube.com/watch?v=ykJmrZ5v0Oo")
        XCTAssertFalse(exercise.isFavourite)
        XCTAssertFalse(exercise.isHold)
        XCTAssertFalse(exercise.userCreated)
        XCTAssertTrue(exercise.category == Category.upperBody.rawValue)
        XCTAssertTrue(exercise.equipment == Equipment.dumbbells.rawValue)
        XCTAssertTrue(exercise.weight!.isEqual(to: NSSet.init(array: [weight_1!, weight_2!]) as! Set<AnyHashable>))
        XCTAssertTrue(exercise.reps!.isEqual(to: NSSet.init(array: [reps_1!, reps_2!]) as! Set<AnyHashable>))
    }
    
    func testDeleteExercise() throws {
        coreDataStack.testContext.delete(exercise)
        do { try coreDataStack.testContext.save() } catch {
            print(error.localizedDescription)
        }

        XCTAssertNil(exercise.weight)
        XCTAssertNil(exercise.reps)
    }
}
