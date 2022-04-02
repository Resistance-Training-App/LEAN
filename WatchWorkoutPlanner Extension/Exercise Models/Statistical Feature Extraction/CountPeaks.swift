//
//  CountPeaks.swift
//  WatchWorkoutPlanner Extension
//
//  Counts the number of local maxima in a 1D array.
//

import Foundation

func countPeaks(data: [Double]) -> Double {
    
    var count: Double = 0
    
    for i in 1...data.count-2 {

        // The value that is being checked.
        let middleValue = data[i]
        var peakSum = 0

        // Count the number of values around the middle value that are less than it.
        for j in i-1...i+1 {
            if (data[j] < middleValue) {
                peakSum += 1
            }
        }

        // If all points are less than the middle value, the middle value is a local maximum.
        if (peakSum == 2) {
            count += 1
        }
    }
    
    return count
}
