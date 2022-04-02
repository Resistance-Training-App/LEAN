//
//  RemoveDuplicateExercises.swift
//  WatchWorkoutPlanner Extension
//
//  Removes duplicated consecutive exercise names from an array.
//

import Foundation

func removeDuplicateExercises(exercises: [String]) -> [String] {
    
    // Remove all rest from an array of predictions.
    let exercisesFiltered = exercises.filter({ $0 != "Other" })

    var exercisesFinal: [String] = []
    var lastExercises = ""
    
    // Only add the prediction to the new array of prediction if the previous prediction was not the
    // same.
    for exercise in exercisesFiltered {
        if (exercise != lastExercises) {
            exercisesFinal.append(exercise)
        }
        lastExercises = exercise
    }
    
    return exercisesFinal
}
