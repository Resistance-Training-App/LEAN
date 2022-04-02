//
//  FindExercisingPercentage.swift
//  Workout Planner
//
//  Find the percentage of time during the set where the user was actually exercising.
//

import Foundation

func findExercisingPercentage(results: [String]) -> Double {
    
    let totalRest = results.filter{$0 == "Other"}.count

    let totalExercise: Double = Double(results.count - totalRest)

    let percentage: Double = (totalExercise / Double(results.count)) * 100.0

    // No exercising was predicated during the exercise set.
    if percentage.isNaN {
        return 0.0
    }
    
    return percentage
}
