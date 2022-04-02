//
//  SelectRepCountingAxis.swift
//  WatchWorkoutPlanner Extension
//
//  Selects the gravity axis with the highest variance which is used to count reps with.
//

import Foundation

func selectRepCountingAxis(motion: MotionManager) -> RepCountingAxis {

    let DMGrvXVariance = calcVariance(data: motion.bufferCopy.DMGrvX)
    let DMGrvYVariance = calcVariance(data: motion.bufferCopy.DMGrvY)
    let DMGrvZVariance = calcVariance(data: motion.bufferCopy.DMGrvZ)

    let maxVariance = max(DMGrvXVariance, DMGrvYVariance, DMGrvZVariance)

    switch maxVariance {

    case DMGrvXVariance:
        motion.repThreshold = ((motion.bufferCopy.DMGrvX.max() ?? 0.0) -
                               (motion.bufferCopy.DMGrvX.min() ?? 0.0)) / 2
        return RepCountingAxis.DMGravX

    case DMGrvYVariance:
        motion.repThreshold = ((motion.bufferCopy.DMGrvY.max() ?? 0.0) -
                               (motion.bufferCopy.DMGrvY.min() ?? 0.0)) / 2
        return RepCountingAxis.DMGravY

    case DMGrvZVariance:
        motion.repThreshold = ((motion.bufferCopy.DMGrvZ.max() ?? 0.0) -
                               (motion.bufferCopy.DMGrvZ.min() ?? 0.0)) / 2
        return RepCountingAxis.DMGravZ

    default:
        motion.repThreshold = ((motion.bufferCopy.DMGrvX.max() ?? 0.0) -
                               (motion.bufferCopy.DMGrvX.min() ?? 0.0)) / 2
        return RepCountingAxis.DMGravX
    }
}

func calcVariance(data: [Double]) -> Double {
    
    let mean = data.reduce(0, +) / Double(data.count)
    var sum: Double = 0.0
    
    for datum in data {
        sum += pow(datum - mean, 2)
    }
    
    let variance = sum / Double(data.count - 1)
    
    return variance
}
