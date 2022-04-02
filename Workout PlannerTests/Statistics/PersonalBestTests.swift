//
//  PersonalBestTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class PersonalBestTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var weight_1: Weight!
    var weight_2: Weight!

    var reps_1: Reps!
    var reps_2: Reps!

    var exercise_1: Exercise!
    var exercise_2: Exercise!
    
    var workout: Workout!
    
    var workoutManager: WorkoutManager!
    
    var profile: Profile!

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
        
        exercise_1 = Exercise.init(context: coreDataStack.testContext)
        exercise_1.order = 0
        exercise_1.name = "Bicep Curl"
        exercise_1.repTime = 3
        exercise_1.desc = "Bicep curl description."
        exercise_1.tutorial = "https://www.youtube.com/watch?v=ykJmrZ5v0Oo"
        exercise_1.isFavourite = false
        exercise_1.isHold = false
        exercise_1.userCreated = false
        exercise_1.picture = Data.init()
        exercise_1.category = Category.upperBody.rawValue
        exercise_1.equipment = Equipment.dumbbells.rawValue
        exercise_1.weight = NSSet.init(array: [weight_1!, weight_2!])
        exercise_1.reps = NSSet.init(array: [reps_1!, reps_2!])
        
        exercise_2 = Exercise.init(context: coreDataStack.testContext)
        exercise_2.order = 0
        exercise_2.name = "Shoulder Press"
        exercise_2.repTime = 3
        exercise_2.desc = "Shoulder press description."
        exercise_2.tutorial = "https://www.youtube.com/watch?v=ykJmrZ5v0Oo"
        exercise_2.isFavourite = false
        exercise_2.isHold = false
        exercise_2.userCreated = false
        exercise_2.picture = Data.init()
        exercise_2.category = Category.upperBody.rawValue
        exercise_2.equipment = Equipment.dumbbells.rawValue
        exercise_2.weight = NSSet.init(array: [weight_1!, weight_2!])
        exercise_2.reps = NSSet.init(array: [reps_1!, reps_2!])
        
        workout = Workout.init(context: coreDataStack.testContext)
        workout.category = Category.upperBody.rawValue
        workout.coolDown = StretchLength.none.rawValue
        workout.id = UUID()
        workout.isCopy = false
        workout.isFavourite = false
        workout.name = "TestWorkout"
        workout.sets = 1
        workout.time = 0.0
        workout.timeCreated = Date.distantPast
        workout.warmUp = StretchLength.none.rawValue
        workout.exercises = NSSet.init(array: [exercise_1!, exercise_2!])
        workout.stretches = NSSet.init()
        
        workoutManager = WorkoutManager.init()
        workoutManager.myWorkout = workout
        
        profile = Profile.init(context: coreDataStack.testContext)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        coreDataStack = nil
        weight_1 = nil
        weight_2 = nil
        reps_1 = nil
        reps_2 = nil
        exercise_1 = nil
        exercise_2 = nil
        workout = nil
        workoutManager = nil
        profile = nil
    }
    
    func testAddWorkoutHistories() throws {
        
        addWorkoutHistory(workout: workoutManager,
                          profile: Profile.init(context: coreDataStack.testContext),
                          viewContext: coreDataStack.testContext)
        
        let personalBests = try coreDataStack.testContext.fetch(PersonalBest.fetchRequest())

        XCTAssertTrue(personalBests.count == 2)
        
        for exercise in workoutManager.myWorkout.exercises?.allObjects as! [Exercise] {
            for weight in exercise.weight?.allObjects as! [Weight] {
                weight.count -= 1
            }
        }
        
        profile.personalBest = NSMutableSet(array: personalBests).copy() as? NSSet

        addWorkoutHistory(workout: workoutManager,
                          profile: profile,
                          viewContext: coreDataStack.testContext)
        
        let updatedPersonalBests = try coreDataStack.testContext.fetch(PersonalBest.fetchRequest())
        XCTAssertTrue(updatedPersonalBests.count == 2)
        XCTAssertTrue(updatedPersonalBests.first?.weight == personalBests.first?.weight)
    }
}
