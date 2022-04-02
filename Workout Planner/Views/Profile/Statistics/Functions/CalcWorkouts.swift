//
//  CalcWorkouts.swift
//  Workout Planner
//
//  Function to calculate the total number of workouts since a given date.
//

import Foundation

func calcWorkouts(workoutHistories: [WorkoutHistory], since: String) -> Int {

    var total = 0
    let date = getDateSince(since: since)
        
    for workoutHistory in workoutHistories {
        if (workoutHistory.timestamp! > date) {
            total += 1
        }
    }
    
    return total
}
