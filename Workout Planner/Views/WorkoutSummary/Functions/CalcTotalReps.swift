//
//  CalcTotalReps.swift
//  Workout Planner
//
//  Function to calculate the total number of reps in a workout
//

import Foundation

func calcTotalReps(sets: Int, exercises: [Exercise]) -> Int {

    var totalReps: Int = 0

    for _ in 0..<sets {
        for exercise in exercises {
            for case let rep as Reps in exercise.reps ?? NSSet.init() {
                totalReps += Int(rep.count)
            }
        }
    }
 
    return totalReps
}
