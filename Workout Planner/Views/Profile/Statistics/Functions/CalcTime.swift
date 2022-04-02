//
//  CalcTime.swift
//  Workout Planner
//
//  Function to calculate the total time completing workouts since a given date.
//

import Foundation

func calcTime(workoutHistories: [WorkoutHistory], since: String) -> Int {

    var total = 0.0
    let date = getDateSince(since: since)
    
    for workoutHistory in workoutHistories {
        if (workoutHistory.timestamp! > date) {
            total += workoutHistory.time
        }
    }
    
    return Int(total)
}
