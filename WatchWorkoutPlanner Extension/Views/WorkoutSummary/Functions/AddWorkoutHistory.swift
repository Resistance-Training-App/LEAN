//
//  AddWorkoutHistory.swift
//  Workout Planner
//
//  Add a new workout history object.
//

import Foundation
import CoreData

func addWorkoutHistory(workout: WorkoutManager,
                       motion: MotionManager,
                       profile: Profile,
                       exercises: [Exercise],
                       viewContext: NSManagedObjectContext) {
    
    // Create workout history object
    let newWorkoutHistory = WorkoutHistory(context: viewContext)
    newWorkoutHistory.id = UUID()
    newWorkoutHistory.time = workout.builder?.elapsedTime ?? 0
    newWorkoutHistory.timestamp = Date()
    newWorkoutHistory.avgHeartRate = workout.averageHeartRate
    newWorkoutHistory.calories = workout.activeEnergy

    if (!workout.justWorkout) {
    
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
        for (index, exercise) in workout.myWorkout.exerciseArray.enumerated() {
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
            
            // Save metrics.
            if exercise.isLearnt {
                for metric in motion.metrics[exist: index] ?? [] {
                    exerciseCopy.addToMetrics(metric.copyEntireObjectGraph(context: viewContext) as! Metrics)
                }
            }

            // Save weights.
            let mutableWeights = NSMutableSet.init()
            for case let weight as Weight in exercise.weight ?? NSSet.init() {
                let weightsCopy = Weight(context: viewContext)
                weightsCopy.order = weight.order
                weightsCopy.count = weight.count
                mutableWeights.add(weightsCopy)
            }
            exerciseCopy.weight = mutableWeights.copy() as? NSSet
            
            // Save reps.
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
        
        newWorkoutHistory.workout = workoutCopy
        newWorkoutHistory.isJustWorkout = false
        
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
        
        profile.statistics?.reps += total_reps
    } else {

        // Create a new workout
        let workoutCopy = Workout(context: viewContext)
        workoutCopy.id = UUID()
        workoutCopy.name = "Open Workout"
        workoutCopy.sets = 1
        workoutCopy.time = workout.builder?.elapsedTime ?? 0
        workoutCopy.timeCreated = Date()
        workoutCopy.isCopy = true

        var total_reps: Int64 = 0

        // Create a copy of each exercise
        let mutableExercises = NSMutableSet.init()

        for (index, exerciseName) in removeDuplicateExercises(exercises: motion.exerciseResults).enumerated() {
            
            let exercise = exercises.filter { $0.name == addSpaces(text: exerciseName) }.first!
    
            // Create copy of existing exercise.
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
            exerciseCopy.order = Int64(index)

            // Save metrics, reps and weight.
            let mutableReps = NSMutableSet.init()
            let mutableWeights = NSMutableSet.init()
            for (setNum, metric) in (motion.metrics[exist: index] ?? []).enumerated() {

                exerciseCopy.addToMetrics(metric.copyEntireObjectGraph(context: viewContext) as! Metrics)
                
                let rep = Reps(context: viewContext)
                rep.order = Int64(index + setNum)
                rep.count = Double(metric.repCount)
                mutableReps.add(rep)
                total_reps += Int64(metric.repCount)
                
                let weight = Weight(context: viewContext)
                weight.order = Int64(index + setNum)
                weight.count = metric.weightChoice
                mutableWeights.add(weight)
            }
            exerciseCopy.addToReps(mutableReps.copy() as! NSSet)
            exerciseCopy.addToWeight(mutableWeights.copy() as! NSSet)
            
            // Add new exercise to mutable set of exercises.
            mutableExercises.add(exerciseCopy)
        }
        // Add exercises to the new workout.
        workoutCopy.addToExercises(mutableExercises.copy() as! NSSet)
        
        // Assign new workout to the workout history object.
        newWorkoutHistory.workout = workoutCopy
        
        // Mark the workout history as an open workout.
        newWorkoutHistory.isJustWorkout = true
        
        profile.statistics?.reps += total_reps
    }

    // Update statistics
    profile.statistics?.workouts += 1
    profile.statistics?.time += workout.builder?.elapsedTime ?? workout.myWorkout.time
    if (workout.builder?.elapsedTime ?? workout.myWorkout.time > profile.statistics?.longestWorkout ?? 0) {
        profile.statistics?.longestWorkout = workout.builder?.elapsedTime ?? workout.myWorkout.time
    }

    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
