//
//  CalcStatisticFeatures.swift
//  WatchWorkoutPlanner Extension
//
//  Calculates general statistical features from a 2D list of data.
//

import Foundation
import Accelerate
import SigmaSwiftStatistics
import Surge

func calcStatisticFeatures(data: [[Double]],
                           features: inout StatisticFeatures,
                           isFFT: Bool) {
    
    for (index, element) in data.enumerated() {
        
        // Mean
        let mean  = vDSP.mean(element)
        
        // Standard deviation
        let std = Sigma.standardDeviationPopulation(element) ?? 0.0

        // Average absolute difference
        let aad = vDSP.mean(element.map { abs($0 - mean) })

        // Minimum value
        let min = element.min() ?? 0.0

        // Maximum value
        let max = element.max() ?? 0.0

        // Minimum-maximum difference
        let maxmin_diff = max - min

        // Median
        let median = Sigma.median(element) ?? 0.0

        // Median absolute deviation
        let mad = vDSP.mean(element.map { abs($0 - median) })

        // Interquartile range
        let IQR = (Sigma.percentile(element, percentile: 0.75) ?? 0.0) -
                  (Sigma.percentile(element, percentile: 0.25) ?? 0.0)

        // Number of values above the mean
        let above_mean = Double(element.filter { $0 > mean }.count)

        // Number of local maxima
        let peak_count = countPeaks(data: element)

        // Skewness
        let skewness = Sigma.skewnessB(element) ?? 0.0

        // Kurtosis
        let kurtosis = Sigma.kurtosisA(element) ?? 0.0

        // Energy
        let energy = vDSP.sum(element.map { pow($0, 2) }) / (isFFT ? 50 : 100)
        
        if (isFFT) {
            switch index {
            case 0:
                features.x_mean_fft = mean
                features.x_std_fft = std
                features.x_aad_fft = aad
                features.x_min_fft = min
                features.x_max_fft = max
                features.x_maxmin_diff_fft = maxmin_diff
                features.x_median_fft = median
                features.x_mad_fft = mad
                features.x_IQR_fft = IQR
                features.x_above_mean_fft = above_mean
                features.x_peak_count_fft = peak_count
                features.x_skewness_fft = skewness
                features.x_kurtosis_fft = kurtosis
                features.x_energy_fft = energy
                
            case 1:
                features.y_mean_fft = mean
                features.y_std_fft = std
                features.y_aad_fft = aad
                features.y_min_fft = min
                features.y_max_fft = max
                features.y_maxmin_diff_fft = maxmin_diff
                features.y_median_fft = median
                features.y_mad_fft = mad
                features.y_IQR_fft = IQR
                features.y_above_mean_fft = above_mean
                features.y_peak_count_fft = peak_count
                features.y_skewness_fft = skewness
                features.y_kurtosis_fft = kurtosis
                features.y_energy_fft = energy
                
            case 2:
                features.z_mean_fft = mean
                features.z_std_fft = std
                features.z_aad_fft = aad
                features.z_min_fft = min
                features.z_max_fft = max
                features.z_maxmin_diff_fft = maxmin_diff
                features.z_median_fft = median
                features.z_mad_fft = mad
                features.z_IQR_fft = IQR
                features.z_above_mean_fft = above_mean
                features.z_peak_count_fft = peak_count
                features.z_skewness_fft = skewness
                features.z_kurtosis_fft = kurtosis
                features.z_energy_fft = energy

            default:
                break
            }
        } else {
            
            // Number of positive values
            let pos_count = Double(element.filter { $0 > 0 }.count)
            
            // Number of negative values
            let neg_count = Double(element.filter { $0 < 0 }.count)
        
            switch index {
            case 0:
                features.x_mean = mean
                features.x_std = std
                features.x_aad = aad
                features.x_min = min
                features.x_max = max
                features.x_maxmin_diff = maxmin_diff
                features.x_median = median
                features.x_mad = mad
                features.x_IQR = IQR
                features.x_above_mean = above_mean
                features.x_peak_count = peak_count
                features.x_skewness = skewness
                features.x_kurtosis = kurtosis
                features.x_energy = energy
                features.x_pos_count = pos_count
                features.x_neg_count = neg_count
                
            case 1:
                features.y_mean = mean
                features.y_std = std
                features.y_aad = aad
                features.y_min = min
                features.y_max = max
                features.y_maxmin_diff = maxmin_diff
                features.y_median = median
                features.y_mad = mad
                features.y_IQR = IQR
                features.y_above_mean = above_mean
                features.y_peak_count = peak_count
                features.y_skewness = skewness
                features.y_kurtosis = kurtosis
                features.y_energy = energy
                features.y_pos_count = pos_count
                features.y_neg_count = neg_count
                
            case 2:
                features.z_mean = mean
                features.z_std = std
                features.z_aad = aad
                features.z_min = min
                features.z_max = max
                features.z_maxmin_diff = maxmin_diff
                features.z_median = median
                features.z_mad = mad
                features.z_IQR = IQR
                features.z_above_mean = above_mean
                features.z_peak_count = peak_count
                features.z_skewness = skewness
                features.z_kurtosis = kurtosis
                features.z_energy = energy
                features.z_pos_count = pos_count
                features.z_neg_count = neg_count

            default:
                break
            }
        }
    }
    
    // Array of squared values.
    let x_squared = data[0].map { pow($0, 2) }
    let y_squared = data[1].map { pow($0, 2) }
    let z_squared = data[2].map { pow($0, 2) }
    
    if (isFFT) {
        
        // Average resultant acceleration
        features.avg_result_accl_fft = vDSP.mean((x_squared + y_squared + z_squared).map { pow($0, 0.5) })

        // Signal magnitude area
        features.sma_fft = data[0].map { abs($0) / 100 }.reduce(0, +) +
                           data[1].map { abs($0) / 100 }.reduce(0, +) +
                           data[2].map { abs($0) / 100 }.reduce(0, +)
    } else {

        // Average resultant acceleration
        features.avg_result_accl = vDSP.mean((x_squared + y_squared + z_squared).map { pow($0, 0.5) })

        // Signal magnitude area
        features.sma = data[0].map { abs($0) / 100 }.reduce(0, +) +
                       data[1].map { abs($0) / 100 }.reduce(0, +) +
                       data[2].map { abs($0) / 100 }.reduce(0, +)
    }
}
