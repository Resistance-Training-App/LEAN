//
//  CalcAverageRangeOfMotion.swift
//  Workout Planner
//
//  Calculates the average range of motion during an exercise set.
//

import Foundation

func calcAverageRangeOfMotion(repRangeOfMotions: [Double]) -> Double {

    if repRangeOfMotions.isEmpty {
        return 0.0
    }

    return repRangeOfMotions.reduce(0, +) / Double(repRangeOfMotions.count)
}
