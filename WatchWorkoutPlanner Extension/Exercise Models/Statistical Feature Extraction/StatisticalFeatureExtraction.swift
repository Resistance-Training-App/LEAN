//
//  StatisticalFeatureExtraction.swift
//  Form Identifier
//
//  Extracts features from shoulder press motion which are input to the model.
//

import Foundation
import Accelerate
import SigmaSwiftStatistics
import Surge

func statisticalFeatureExtraction(buffer: Motion) -> StatisticFeatures {
    
    var features = StatisticFeatures()
    
    // Extract general statistic features from the x, y and z dimensions.
    calcStatisticFeatures(data: [buffer.DMUAccelX, buffer.DMUAccelY, buffer.DMUAccelZ],
                          features: &features,
                          isFFT: false)

    // Converting the signals from time domain to frequency domain using FFT.
    let x_list_fft = Array(Surge.fft(buffer.DMUAccelX)[1...51]).map { $0 * 100 }
    let y_list_fft = Array(Surge.fft(buffer.DMUAccelY)[1...51]).map { $0 * 100 }
    let z_list_fft = Array(Surge.fft(buffer.DMUAccelZ)[1...51]).map { $0 * 100 }

    // Extract general statistic features from the fft x, y and z dimensions.
    calcStatisticFeatures(data: [x_list_fft, y_list_fft, z_list_fft],
                          features: &features,
                          isFFT: true)
    
    return features
}
