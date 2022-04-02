//
//  CalcEccentricConcentricRatio.swift
//  Workout Planner
//
//  Calculates the ratio of average time spent between the start and middle of the rep, and the
//  middle and end of the rep.
//

import Foundation

func calcEccentricConcentricRatio(repStartTimes: [Double],
                                  repMiddleTimes: [Double],
                                  repEndTimes: [Double],
                                  isEccentric: Bool) -> Double {
    
    if (repStartTimes.isEmpty || repMiddleTimes.isEmpty || repEndTimes.isEmpty) {
        return 0.0
    }
    
    let avgEccentricTime = calcAverageRepTime(repStartTimes: repStartTimes,
                                              repEndTimes: repMiddleTimes)
    
    let avgConcentricTime = calcAverageRepTime(repStartTimes: repMiddleTimes,
                                              repEndTimes: repEndTimes)
    
    let avgTotalTime = avgEccentricTime + avgConcentricTime
    
    if isEccentric {
        return (avgEccentricTime / avgTotalTime) * 100
    } else {
        return (avgConcentricTime / avgTotalTime) * 100
    }
}
