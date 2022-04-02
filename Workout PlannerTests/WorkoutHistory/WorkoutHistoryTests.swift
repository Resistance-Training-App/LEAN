//
//  WorkoutHistoryTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner
import CoreData

class WorkoutHistoryTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!

    var weight_1: Weight!
    var weight_2: Weight!

    var reps_1: Reps!
    var reps_2: Reps!

    var exercise_1: Exercise!
    var exercise_2: Exercise!
    
    var workout: Workout!
    
    var profile: Profile!
    
    var workoutManager: WorkoutManager!

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
        
        profile = Profile.init(context: coreDataStack.testContext)
        profile.statistics = Statistics.init(context: coreDataStack.testContext)
        
        workoutManager = WorkoutManager.init()
        workoutManager.myWorkout = workout
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
        profile = nil
        workoutManager = nil
    }

    func testAddWorkoutHistory() throws {
        
        addWorkoutHistory(workout: workoutManager,
                          profile: profile,
                          viewContext: coreDataStack.testContext)
        
        let workoutHistories = try coreDataStack.testContext.fetch(WorkoutHistory.fetchRequest())

        XCTAssertTrue(workoutHistories.count == 1)
        XCTAssertTrue(workoutHistories.first?.workout?.name == workout.name)
        XCTAssertTrue(workoutHistories.first?.workout?.exerciseArray.count == 2)
        
        let profile = try coreDataStack.testContext.fetch(Profile.fetchRequest()).first!

        XCTAssertTrue(profile.statistics!.workouts == 1)
        XCTAssertTrue(profile.statistics!.time == workoutHistories.first!.time)
        XCTAssertTrue(profile.statistics!.reps == 35)
    }
    
    func testRemoveWorkoutHistory() throws {
        
        let newWorkoutHistory = WorkoutHistory.init(context: coreDataStack.testContext)
        newWorkoutHistory.workout = workout

        do { try coreDataStack.testContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
        
        removeWorkoutHistory(workoutHistory: newWorkoutHistory,
                             profile: profile,
                             viewContext: coreDataStack.testContext)

        let workoutHistories = try coreDataStack.testContext.fetch(WorkoutHistory.fetchRequest())

        XCTAssertTrue(workoutHistories.isEmpty)
        
        let profile = try coreDataStack.testContext.fetch(Profile.fetchRequest()).first!

        XCTAssertTrue(profile.statistics!.workouts == -1)
        XCTAssertTrue(profile.statistics!.time == 0.0)
        XCTAssertTrue(profile.statistics!.reps == -35)
    }
}
