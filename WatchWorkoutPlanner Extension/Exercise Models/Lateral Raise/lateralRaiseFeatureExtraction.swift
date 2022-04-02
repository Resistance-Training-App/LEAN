//
//  lateralRaiseFeatureExtraction.swift
//  Form Identifier
//

import Foundation

func lateralRaiseFeatureExtraction(buffer: Motion) -> LateralRaiseFeatures {

    // The sum of the difference between the largest and smallest values of gravity X.
    let gravX_height = (buffer.DMGrvX.max() ?? 0) - (buffer.DMGrvX.min() ?? 0)
    
    // The maximum rotation rate Y.
    let rotY_max = max(buffer.DMRotY.max() ?? 0, abs(buffer.DMRotY.min() ?? 0))
    
    // The difference between the largest and smallest values of roll.
    let roll_height = abs(buffer.DMRoll.max() ?? 0) - abs(buffer.DMRoll.min() ?? 0)

    let avgGravX = movingAverage(data: buffer.DMGrvX, scope: 5)
    let avgGravZ = movingAverage(data: buffer.DMGrvZ, scope: 5)
    let avgRoll = movingAverage(data: buffer.DMRoll, scope: 5)

    var gravXTP = 0
    var gravZTP = 0
    var gravRollTP = 0

    // Counts the number of turning points for Gravity X, Z and Roll.
    for i in 1...avgGravX.count-2 {

        if isTurningPoint(data: avgGravX, index: i, scope: 1) {
            gravXTP += 1
        }

        if isTurningPoint(data: avgGravZ, index: i, scope: 1) {
            gravZTP += 1
        }
        
        if isTurningPoint(data: avgRoll, index: i, scope: 1) {
            gravRollTP += 1
        }
    }

    // The minimum roll value captured during the motion window.
    let roll_min = buffer.DMRoll.min() ?? 0
    
    return LateralRaiseFeatures(gravX_height: gravX_height,
                                rotY_max: rotY_max,
                                TP_sum: Double((gravXTP + gravZTP + gravRollTP)) / 10,
                                roll_min: roll_min,
                                roll_height: roll_height)
}
