//
//  IsTurningPoint.swift
//  WatchWorkoutPlanner Extension
//
//  Identifies if a specific value is a turning point based on N number of points surrounding it.
//

import Foundation

func isTurningPoint(data: [Double], index: Int, scope: Int) -> Bool {
    
    if data.isEmpty || data.count < index+1 || data.count < scope {
        return false
    }
    
    // The value that is being checked.
    let middleValue = data[index]
    var peakSum = 0
    var troughSum = 0

    // Count the number of values around the middle value that are less than and greater than it.
    for i in index-scope...index+scope {
        if (data[i] < middleValue) {
            peakSum += 1
        } else if (data[i] > middleValue) {
            troughSum += 1
        }
    }

    // If all points are either all less than or all greater than the middle value, the middle value
    // is a local maximum or minimum.
    if (peakSum == scope * 2 || troughSum == scope * 2) {
        return true
    } else {
        return false
    }
}
