//
//  CalcWorkoutTime.swift
//  Workout Planner
//
//  Function to estimate the time a workout will take based on the stretches and exercises it contains.
//

import Foundation

func calcTimeWorkout(newWorkoutData: Workout.Template) -> Double {

    var workoutTime: Double = 0
    
    let exerciseArray = newWorkoutData.exercises.sortedArray(using:
                        [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)]) as! [Exercise]

    for exercise in exerciseArray {
        for case let rep as Reps in exercise.reps ?? NSSet.init() {
            workoutTime += exercise.repTime * Double(rep.count)
        }
    }

    // Multiply by number of sets.
    workoutTime *= newWorkoutData.sets

    // Typical time taken for rest.
    workoutTime *= 3

    return workoutTime
}

func calcTimeWorkout(workout: Workout) -> Double {

    var workoutTime: Double = 0

    // Time taken for exercises.
    for exercise in workout.exerciseArray {
        for case let rep as Reps in exercise.reps ?? NSSet.init() {
            // Estimated time for one rep multiplied by the target number of reps.
            workoutTime += exercise.repTime * Double(rep.count)
        }
    }

    // Multiply by number of sets.
    workoutTime *= Double(workout.sets)

    // Typical time taken for rest.
    workoutTime *= 3

    return workoutTime
}
