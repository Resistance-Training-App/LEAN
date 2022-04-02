//
//  CalcAverageRepTime.swift
//  Workout Planner
//
//  Calculates the average rep time of an exercise set from the times at which each rep started and
//  finished.
//

import Foundation

func calcAverageRepTime(repStartTimes: [Double], repEndTimes: [Double]) -> Double {
    
    var repTimes: [Double] = []

    for (repStartTime, repEndTime) in zip(repStartTimes, repEndTimes) {
        repTimes.append(repEndTime  - repStartTime)
    }
    
    let avgRepTime = repTimes.reduce(0, +) / Double(repTimes.count)
    
    // No reps found.
    if avgRepTime.isNaN {
        return 0.0
    }
    
    return avgRepTime
}
