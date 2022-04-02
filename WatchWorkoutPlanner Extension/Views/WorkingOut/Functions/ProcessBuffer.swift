//
//  ProcessBuffer.swift
//  WatchWorkoutPlanner Extension
//
//  Processes a window of motion by identifying the motion type and counting any potential reps.
//

import Foundation

func processBuffer(motion: MotionManager) {
    
    // Select axis with greatest variance for rep counting.
    let selectedAxis = selectRepCountingAxis(motion: motion)

    // Append the new motion to the rep and time buffers used for rep counting.
    // Only second half as the window is overlapped with old, already processed data.
    let timeBufferCount = motion.bufferCopy.TimeStamp.count
    let rangeBufferCount = motion.bufferCopy.DMRoll.count

    if (timeBufferCount > 0) {
        motion.timeBuffer.append(contentsOf:
            Array(motion.bufferCopy.TimeStamp[timeBufferCount/2...timeBufferCount-1]))
        motion.rangeBuffer.append(contentsOf:
            Array(motion.bufferCopy.DMRoll[rangeBufferCount/2...rangeBufferCount-1]))

        switch selectedAxis {
        case .DMGravX:
            let repBufferCount = motion.bufferCopy.DMGrvX.count
            motion.repBuffer.append(contentsOf:
                Array(motion.bufferCopy.DMGrvX[repBufferCount/2...repBufferCount-1]))
        case .DMGravY:
            let repBufferCount = motion.bufferCopy.DMGrvY.count
            motion.repBuffer.append(contentsOf:
                Array(motion.bufferCopy.DMGrvY[repBufferCount/2...repBufferCount-1]))
        case .DMGravZ:
            let repBufferCount = motion.bufferCopy.DMGrvZ.count
            motion.repBuffer.append(contentsOf:
                Array(motion.bufferCopy.DMGrvZ[repBufferCount/2...repBufferCount-1]))
        }
    }

    // Make prediction on the current motion type.
    makePrediction(motion: motion)

    // Reps are only looked for when the motion type prediction suggests the user is currently
    // performing the exercise. Prevents false positives in between sets and increases efficiency.
    let latestMotion = motion.results.last ?? "Other"
    let secondLatestMotion = motion.results[exist: motion.results.count-2] ?? "Other"

    if (latestMotion != "Other" || secondLatestMotion != "Other") {
        repCounter(motion: motion)

    // Keep the rep and time buffers updated ready for the user to start exercising.
    } else if (motion.repBuffer.count >= ModelManager.predictionWindowSize &&
               motion.timeBuffer.count >= ModelManager.predictionWindowSize &&
               motion.rangeBuffer.count >= ModelManager.predictionWindowSize) {
        
        motion.repBuffer = Array(motion.repBuffer.dropFirst(ModelManager.frequency))
        motion.timeBuffer = Array(motion.timeBuffer.dropFirst(ModelManager.frequency))
        motion.rangeBuffer = Array(motion.rangeBuffer.dropFirst(ModelManager.frequency))
    }
}
