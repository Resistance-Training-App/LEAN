//
//  GetRangeOfMotion.swift
//  WatchWorkoutPlanner Extension
//
//  Calculates the range of motion of a single repetition in an exercise set.
//

import Foundation

func getRangeOfMotion(motion: MotionManager,
                      repStartTime: Double,
                      repEndTime: Double) -> Double {

        
    // Find the index at which the rep started and finished.
    let repStart = motion.timeBuffer.firstIndex(of: repStartTime) ?? 0
    let repEnd = motion.timeBuffer.firstIndex(of: repEndTime) ?? 0

    if (repStart < repEnd) && (motion.rangeBuffer.count > repStart) && (motion.rangeBuffer.count > repStart) {
    
        // Calculate the range of motion.
        let rangeOfMotion = getRollAngle(roll: Array(motion.rangeBuffer[repStart...repEnd]).map(abs))
        
        return rangeOfMotion
    }

    return 0.0
}
