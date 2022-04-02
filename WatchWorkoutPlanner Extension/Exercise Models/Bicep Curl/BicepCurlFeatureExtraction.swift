//
//  BicepCurlFeatureExtraction.swift
//  Form Identifier WatchKit Extension
//
//  Extracts features from bicep curl motion which are input to the model.
//

import Foundation

func bicepCurlFeatureExtraction(buffer: Motion) -> BicepCurlFeatures {
    
    
    // The difference between the largest and smallest values of gravity X.
    let gravX_height = (buffer.DMGrvX.max() ?? 0) - (buffer.DMGrvX.min() ?? 0)
    
    // The maximum acceleration X.
    let accelX_max = max(buffer.DMUAccelX.max() ?? 0, abs(buffer.DMUAccelX.min() ?? 0))
    
    // Counts the number of times in the motion window rotation Y and Z are not both positive or
    // negative. If this number exceeds a threshold the feature is '1', otherwise '0'.
    var rot_symmetry = 0
    var rot_diff = 0

    for (Y, Z) in zip(buffer.DMRotY, buffer.DMRotZ) {
        if ((Y < 0 && Z > 0) || (Y > 0 && Z < 0)) {
            rot_diff += 1
        }
    }

    if rot_diff > 110 {
        rot_symmetry = 1
    }
    
    return BicepCurlFeatures(gravX_height: gravX_height,
                             rot_symmetry: Double(rot_symmetry),
                             accelX_max: accelX_max)
}
