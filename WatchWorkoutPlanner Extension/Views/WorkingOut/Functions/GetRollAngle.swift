//
//  GetRollAngle.swift
//  WatchWorkoutPlanner Extension
//
//  Calculates the overall angle based on the roll angles during the rep.
//

import Foundation

func getRollAngle(roll: [Double]) -> Double {

    var turningPoints: [Int] = []
    var angles: [Double] = []

    // The number of values either side of the current value to check if the current value is a
    // turning point.
    let scope = 1

    if roll.count < scope * 2 + 1 {
        return 0
    }

    for i in scope...roll.count - 1 - scope {

        // Found a turning point.
        if isTurningPoint(data: roll, index: i, scope: scope) {
            if turningPoints.isEmpty {
                turningPoints.append(i)
            
            // Ignore turning points too close together.
            } else if abs(turningPoints.last! - i) > 5 {
                turningPoints.append(i)
            }
        }
    }

    if turningPoints.count % 2 == 1 {
        turningPoints.insert(0, at: 0)
    }

    for i in stride(from: 0, to: turningPoints.count, by: 2) {
        angles.append(abs(roll[turningPoints[i]] - roll[turningPoints[i+1]]))
    }

    return radToDeg(angle: angles.reduce(0, +))
}
