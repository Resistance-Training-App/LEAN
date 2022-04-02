//
//  AddWorkoutHistory.swift
//  Workout Planner
//
//  Add a new workout history object.
//

import Foundation
import CoreData

func addWorkoutHistory(workout: WorkoutManager, profile: Profile, viewContext: NSManagedObjectContext) {
    
    // Create a copy of the workout
    let workoutCopy = Workout(context: viewContext)
    workoutCopy.id = UUID()
    workoutCopy.name = workout.myWorkout.name
    workoutCopy.isFavourite = workout.myWorkout.isFavourite
    workoutCopy.sets = workout.myWorkout.sets
    workoutCopy.time = workout.myWorkout.time
    workoutCopy.timeCreated = workout.myWorkout.timeCreated
    workoutCopy.isCopy = true
    workoutCopy.category = workout.myWorkout.category

    var total_reps: Int64 = 0
    
    // Create a copy of each exercise
    let mutableExercises = NSMutableSet.init()
    for exercise in workout.myWorkout.exerciseArray {
        let exerciseCopy = Exercise(context: viewContext)
        exerciseCopy.id = UUID()
        exerciseCopy.name = exercise.name
        exerciseCopy.repTime = exercise.repTime
        exerciseCopy.desc = exercise.desc
        exerciseCopy.tutorial = exercise.tutorial
        exerciseCopy.isFavourite = exercise.isFavourite
        exerciseCopy.isHold = exercise.isHold
        exerciseCopy.picture = exercise.picture
        exerciseCopy.isLearnt = exercise.isLearnt
        exerciseCopy.isRotation = exercise.isRotation
        exerciseCopy.userCreated = exercise.userCreated
        exerciseCopy.category = exercise.category
        exerciseCopy.equipment = exercise.equipment
        exerciseCopy.order = exercise.order
        exerciseCopy.metrics = exercise.metrics
        
        let mutableWeights = NSMutableSet.init()
        for case let weight as Weight in exercise.weight ?? NSSet.init() {
            let weightsCopy = Weight(context: viewContext)
            weightsCopy.order = weight.order
            weightsCopy.count = weight.count
            mutableWeights.add(weightsCopy)
        }
        exerciseCopy.weight = mutableWeights.copy() as? NSSet
        
        let mutableReps = NSMutableSet.init()
        for case let rep as Reps in exercise.reps ?? NSSet.init() {
            let repsCopy = Reps(context: viewContext)
            repsCopy.order = rep.order
            repsCopy.count = rep.count
            mutableReps.add(repsCopy)
            total_reps += Int64(rep.count)
        }
        exerciseCopy.reps = mutableReps.copy() as? NSSet
        
        mutableExercises.add(exerciseCopy)
    }
    workoutCopy.exercises = mutableExercises.copy() as? NSSet

    // Create workout history object
    let newWorkoutHistory = WorkoutHistory(context: viewContext)
    newWorkoutHistory.id = UUID()
    newWorkoutHistory.workout = workoutCopy
    newWorkoutHistory.time = workout.timer.secondsElapsed
    newWorkoutHistory.timestamp = Date()
    
    
    // Iterate through each exercise in the workout updating any of the user's personal bests.
    let personalBests = NSMutableSet(set: profile.personalBest ?? NSSet.init())
    for exercise in workout.myWorkout.exerciseArray {
        let existingPersonalBest = profile.personalBestArray.filter({$0.exerciseName == exercise.name})
        let maxWeight = exercise.weightArray.max { $0.count < $1.count }?.count ?? 0
        
        // If there's an existing personal best, update the weight if higher.
        if (existingPersonalBest.count == 1) {
            if (maxWeight > existingPersonalBest.first?.weight ?? 0) {
                existingPersonalBest.first?.weight = maxWeight
            }
        // Otherwise add a new personal best, the exercise has not been completed before.
        } else {
            let newPersonalBest = PersonalBest(context: viewContext)
            newPersonalBest.exerciseName = exercise.name ?? ""
            newPersonalBest.weight = maxWeight
            personalBests.add(newPersonalBest)
        }
    }
    profile.personalBest = personalBests.copy() as? NSSet
    
    // Update statistics
    profile.statistics?.workouts += 1
    profile.statistics?.time += workout.timer.secondsElapsed
    profile.statistics?.reps += total_reps
    if (workout.timer.secondsElapsed > profile.statistics?.longestWorkout ?? 0) {
        profile.statistics?.longestWorkout = workout.timer.secondsElapsed
    }

    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
