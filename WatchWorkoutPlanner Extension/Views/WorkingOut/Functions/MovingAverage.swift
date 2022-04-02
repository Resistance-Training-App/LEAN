//
//  MovingAverage.swift
//  WatchWorkoutPlanner Extension
//
//  Applies a moving average to an array.
//

import Foundation

func movingAverage(data: [Double], scope: Int) -> [Double] {

    var avgData: [Double] = []

    if (data.count < scope || scope < 1) {
        return []
    }

    for endIndex in scope...data.count {

        // The range of each element within the moving average.
        let range = Range(uncheckedBounds: (lower: endIndex - scope, upper: endIndex))

        // The sum of all elements within this range.
        let sum = data[range].reduce(0) { (point_1, point_2) -> Double in return point_1 + point_2 }

        // Mean value.
        let avg = sum / Double(scope)

        avgData.append(avg)
    }
    
    return avgData
}
