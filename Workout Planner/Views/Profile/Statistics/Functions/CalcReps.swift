//
//  CalcReps.swift
//  Workout Planner
//
//  Function to calculate the total number of reps since a given date.
//

import Foundation

func calcReps(workoutHistories: [WorkoutHistory], since: String) -> Int {

    var total = 0
    let date = getDateSince(since: since)
    
    for workoutHistory in workoutHistories {
        if (workoutHistory.timestamp! > date) {
            for exercise in workoutHistory.workout?.exerciseArray ?? [] {
                for case let rep as Reps in exercise.reps ?? NSSet.init() {
                    total += Int(rep.count)
                }
            }
        }
    }
    
    return total
}
