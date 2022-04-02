//
//  WorkoutTests.swift
//  Workout PlannerTests
//

import XCTest
@testable import Workout_Planner

class WorkoutTests: XCTestCase {

    var coreDataStack: CoreDataStack!

    var weight_1: Weight!
    var weight_2: Weight!

    var reps_1: Reps!
    var reps_2: Reps!

    var exercise_1: Exercise!
    var exercise_2: Exercise!
    
    var workout: Workout!

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
    }

    func testAddExercise() throws {
        XCTAssertNotNil(workout, "Workout should not be nil")
        XCTAssertTrue(workout.category == Category.upperBody.rawValue)
        XCTAssertTrue(workout.coolDown == StretchLength.none.rawValue)
        XCTAssertTrue(workout.isCopy == false)
        XCTAssertTrue(workout.isFavourite == false)
        XCTAssertTrue(workout.name == "TestWorkout")
        XCTAssertTrue(workout.sets == 1)
        XCTAssertTrue(workout.time == 0.0)
        XCTAssertTrue(workout.timeCreated == Date.distantPast)
        XCTAssertTrue(workout.warmUp == StretchLength.none.rawValue)
        XCTAssertTrue(workout.exercises == NSSet.init(array: [exercise_1!, exercise_2!]))
        XCTAssertTrue(workout.stretches == NSSet.init())
    }
    
    func testDeleteExercise() throws {
        coreDataStack.testContext.delete(workout)
        do { try coreDataStack.testContext.save() } catch {
            print(error.localizedDescription)
        }

        XCTAssertNil(workout.exercises)
        XCTAssertNil(workout.stretches)
    }
    
    func testExercisesToArray() throws {
        let exerciseArray = exercisesToArray(exercises: workout.exercises!)
        XCTAssertTrue(exerciseArray == workout.exercises!.allObjects as! [Exercise])
    }
    
    func testMostCommonCategory() throws {
        let category = mostCommonCategory(exercises: workout.exercises!.allObjects as! [Exercise])
        XCTAssertTrue(category == "Upper Body")
    }
    
    func testCalcTimeWorkout() throws {
        let time = calcTimeWorkout(workout: workout)
        XCTAssertTrue(time == 315.0)
    }
    
    func testCancelWorkoutCreation() throws {
        var showNewWorkout = true
        var newWorkoutData = Workout.Template()
        newWorkoutData.name = "NewWorkout"
        newWorkoutData.sets = 2
        newWorkoutData.exercises = [exercise_1!]
        newWorkoutData.warmUp = StretchLength.short
        newWorkoutData.coolDown = StretchLength.short

        cancelWorkoutCreation(showNewWorkout: &showNewWorkout,
                              newWorkoutData: &newWorkoutData,
                              exercises: [],
                              viewContext: coreDataStack.testContext)
        
        XCTAssertFalse(showNewWorkout)
        XCTAssertTrue(newWorkoutData.name == "")
        XCTAssertTrue(newWorkoutData.sets == 1.0)
        XCTAssertTrue(newWorkoutData.exercises == [])
        XCTAssertTrue(newWorkoutData.warmUp == StretchLength.none)
        XCTAssertTrue(newWorkoutData.coolDown == StretchLength.none)
    }
    
    func testCreateNewWorkout() throws {
        var showNewWorkout = true
        var newWorkoutData = Workout.Template()
        newWorkoutData.name = "NewWorkout"
        newWorkoutData.sets = 2
        newWorkoutData.exercises = [exercise_1!]
        newWorkoutData.warmUp = StretchLength.short
        newWorkoutData.coolDown = StretchLength.short

        createNewWorkout(showNewWorkout: &showNewWorkout,
                         newWorkoutData: &newWorkoutData,
                         viewContext: coreDataStack.testContext)
        
        XCTAssertFalse(showNewWorkout)
        XCTAssertTrue(newWorkoutData.name == "")
        XCTAssertTrue(newWorkoutData.sets == 1.0)
        XCTAssertTrue(newWorkoutData.exercises == [])
        XCTAssertTrue(newWorkoutData.warmUp == StretchLength.none)
        XCTAssertTrue(newWorkoutData.coolDown == StretchLength.none)
    }
    
    func testEditWorkout() throws {
        var showEdit = true
        var workoutData = Workout.Template()
        workoutData.name = "NewWorkout"
        workoutData.sets = 2
        workoutData.exercises = [exercise_1!]
        workoutData.warmUp = StretchLength.short
        workoutData.coolDown = StretchLength.short
        
        var deletedExercises = [exercise_1!]

        editWorkout(showEdit: &showEdit,
                    workoutData: &workoutData,
                    myWorkout: workout!,
                    deletedExercises: &deletedExercises,
                    viewContext: coreDataStack.testContext)
        
        XCTAssertFalse(showEdit)
        XCTAssertTrue(workoutData.name == "")
        XCTAssertTrue(workoutData.sets == 1.0)
        XCTAssertTrue(workoutData.exercises == [])
        XCTAssertTrue(workoutData.warmUp == StretchLength.none)
        XCTAssertTrue(workoutData.coolDown == StretchLength.none)
        
        XCTAssertTrue(workout.name == "NewWorkout")
        XCTAssertTrue(workout.sets == 2)
        XCTAssertTrue(workout.warmUp == StretchLength.short.rawValue)
        XCTAssertTrue(workout.coolDown == StretchLength.short.rawValue)
        
        XCTAssertTrue(deletedExercises.isEmpty)
    }
}
