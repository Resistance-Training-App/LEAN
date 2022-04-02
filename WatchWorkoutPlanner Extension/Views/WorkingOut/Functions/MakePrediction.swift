//
//  MakePrediction.swift
//  WatchWorkoutPlanner Extension
//
//  Make a motion type prediction and store the results.
//

import Foundation

func makePrediction(motion: MotionManager) {
    
    var prediction: String = "Other"
    var predictionProbs: [String: Double] = [:]
    
    // Make prediction based on the current selected model.
    switch motion.modelManager.selectedModel {

    case .BicepCurl:

        let features = bicepCurlFeatureExtraction(buffer: motion.bufferCopy)

        let input = BicepCurlInput(accelX_max: features.accelX_max,
                                   gravX_height: features.gravX_height,
                                   rot_symmetry: features.rot_symmetry)

        (predictionProbs, prediction) = motion.modelManager.bicepCurlPrediction(input: input) ?? ([:], "Other")

    case .LateralRaise:

        let features = lateralRaiseFeatureExtraction(buffer: motion.bufferCopy)

        let input = LateralRaiseInput(TP_sum: features.TP_sum,
                                      gravX_height: features.gravX_height,
                                      roll_height: features.roll_height,
                                      roll_min: features.roll_min,
                                      rotY_max: features.rotY_max)

        (predictionProbs, prediction) = motion.modelManager.lateralRaisePrediction(input: input) ?? ([:], "Other")
        
    case .ShoulderPress:

        let features = statisticalFeatureExtraction(buffer: motion.bufferCopy)

        let input = ShoulderPressInput(avg_result_accl: features.avg_result_accl ?? 0.0,
                                       avg_result_accl_fft: features.avg_result_accl_fft ?? 0.0,
                                       sma: features.sma ?? 0.0, sma_fft: features.sma_fft ?? 0.0,

                                       x_IQR: features.x_IQR ?? 0.0, x_IQR_fft: features.x_IQR_fft ?? 0.0,
                                       x_aad: features.x_aad ?? 0.0, x_aad_fft: features.x_aad_fft ?? 0.0,
                                       x_above_mean: features.x_above_mean ?? 0.0, x_above_mean_fft: features.x_above_mean_fft ?? 0.0,
                                       x_energy: features.x_energy ?? 0.0, x_energy_fft: features.x_energy_fft ?? 0.0,
                                       x_kurtosis: features.x_kurtosis ?? 0.0, x_kurtosis_fft: features.x_kurtosis_fft ?? 0.0,
                                       x_mad: features.x_mad ?? 0.0, x_mad_fft: features.x_mad_fft ?? 0.0,
                                       x_max: features.x_max ?? 0.0, x_max_fft: features.x_max_fft ?? 0.0,
                                       x_maxmin_diff: features.x_maxmin_diff ?? 0.0, x_maxmin_diff_fft: features.x_maxmin_diff_fft ?? 0.0,
                                       x_mean: features.x_mean ?? 0.0, x_mean_fft: features.x_mean_fft ?? 0.0,
                                       x_median: features.x_median ?? 0.0, x_median_fft: features.x_median_fft ?? 0.0,
                                       x_min: features.x_min ?? 0.0, x_min_fft: features.x_min_fft ?? 0.0,
                                       x_neg_count: features.x_neg_count ?? 0.0,
                                       x_peak_count: features.x_peak_count ?? 0.0, x_peak_count_fft: features.x_peak_count_fft ?? 0.0,
                                       x_pos_count: features.x_pos_count ?? 0.0,
                                       x_skewness: features.x_skewness ?? 0.0, x_skewness_fft: features.x_skewness_fft ?? 0.0,
                                       x_std: features.x_std ?? 0.0, x_std_fft: features.x_std_fft ?? 0.0,

                                       y_IQR: features.y_IQR ?? 0.0, y_IQR_fft: features.y_IQR_fft ?? 0.0,
                                       y_aad: features.y_aad ?? 0.0, y_aad_fft: features.y_aad_fft ?? 0.0,
                                       y_above_mean: features.y_above_mean ?? 0.0, y_above_mean_fft: features.y_above_mean_fft ?? 0.0,
                                       y_energy: features.y_energy ?? 0.0, y_energy_fft: features.y_energy_fft ?? 0.0,
                                       y_kurtosis: features.y_kurtosis ?? 0.0, y_kurtosis_fft: features.y_kurtosis_fft ?? 0.0,
                                       y_mad: features.y_mad ?? 0.0, y_mad_fft: features.y_mad_fft ?? 0.0,
                                       y_max: features.y_max ?? 0.0, y_max_fft: features.y_max_fft ?? 0.0,
                                       y_maxmin_diff: features.y_maxmin_diff ?? 0.0, y_maxmin_diff_fft: features.y_maxmin_diff_fft ?? 0.0,
                                       y_mean: features.y_mean ?? 0.0, y_mean_fft: features.y_mean_fft ?? 0.0,
                                       y_median: features.y_median ?? 0.0, y_median_fft: features.y_median_fft ?? 0.0,
                                       y_min: features.y_min ?? 0.0, y_min_fft: features.y_min_fft ?? 0.0,
                                       y_neg_count: features.y_neg_count ?? 0.0,
                                       y_peak_count: features.y_peak_count ?? 0.0, y_peak_count_fft: features.y_peak_count_fft ?? 0.0,
                                       y_pos_count: features.y_pos_count ?? 0.0,
                                       y_skewness: features.y_skewness ?? 0.0, y_skewness_fft: features.y_skewness_fft ?? 0.0,
                                       y_std: features.y_std ?? 0.0, y_std_fft: features.y_std_fft ?? 0.0,

                                       z_IQR: features.z_IQR ?? 0.0, z_IQR_fft: features.z_IQR_fft ?? 0.0,
                                       z_aad: features.z_aad ?? 0.0, z_aad_fft: features.z_aad_fft ?? 0.0,
                                       z_above_mean: features.z_above_mean ?? 0.0, z_above_mean_fft: features.z_above_mean_fft ?? 0.0,
                                       z_energy: features.z_energy ?? 0.0, z_energy_fft: features.z_energy_fft ?? 0.0,
                                       z_kurtosis: features.z_kurtosis ?? 0.0, z_kurtosis_fft: features.z_kurtosis_fft ?? 0.0,
                                       z_mad: features.z_mad ?? 0.0, z_mad_fft: features.z_mad_fft ?? 0.0,
                                       z_max: features.z_max ?? 0.0, z_max_fft: features.z_max_fft ?? 0.0,
                                       z_maxmin_diff: features.z_maxmin_diff ?? 0.0, z_maxmin_diff_fft: features.z_maxmin_diff_fft ?? 0.0,
                                       z_mean: features.z_mean ?? 0.0, z_mean_fft: features.z_mean_fft ?? 0.0,
                                       z_median: features.z_median ?? 0.0, z_median_fft: features.z_median_fft ?? 0.0,
                                       z_min: features.z_min ?? 0.0, z_min_fft: features.z_min_fft ?? 0.0,
                                       z_neg_count: features.z_neg_count ?? 0.0,
                                       z_peak_count: features.z_peak_count ?? 0.0, z_peak_count_fft: features.z_peak_count_fft ?? 0.0,
                                       z_pos_count: features.z_pos_count ?? 0.0,
                                       z_skewness: features.z_skewness ?? 0.0, z_skewness_fft: features.z_skewness_fft ?? 0.0,
                                       z_std: features.z_std ?? 0.0, z_std_fft: features.z_std_fft ?? 0.0)

        (predictionProbs, prediction) = motion.modelManager.shoudlerPressPrediction(input: input) ?? ([:], "Other")
        
    case .Exercise:

        let features = statisticalFeatureExtraction(buffer: motion.bufferCopy)

        let input = ExercisesInput(avg_result_accl: features.avg_result_accl ?? 0.0,
                                  avg_result_accl_fft: features.avg_result_accl_fft ?? 0.0,
                                  sma: features.sma ?? 0.0, sma_fft: features.sma_fft ?? 0.0,

                                  x_IQR: features.x_IQR ?? 0.0, x_IQR_fft: features.x_IQR_fft ?? 0.0,
                                  x_aad: features.x_aad ?? 0.0, x_aad_fft: features.x_aad_fft ?? 0.0,
                                  x_above_mean: features.x_above_mean ?? 0.0, x_above_mean_fft: features.x_above_mean_fft ?? 0.0,
                                  x_energy: features.x_energy ?? 0.0, x_energy_fft: features.x_energy_fft ?? 0.0,
                                  x_kurtosis: features.x_kurtosis ?? 0.0, x_kurtosis_fft: features.x_kurtosis_fft ?? 0.0,
                                  x_mad: features.x_mad ?? 0.0, x_mad_fft: features.x_mad_fft ?? 0.0,
                                  x_max: features.x_max ?? 0.0, x_max_fft: features.x_max_fft ?? 0.0,
                                  x_maxmin_diff: features.x_maxmin_diff ?? 0.0, x_maxmin_diff_fft: features.x_maxmin_diff_fft ?? 0.0,
                                  x_mean: features.x_mean ?? 0.0, x_mean_fft: features.x_mean_fft ?? 0.0,
                                  x_median: features.x_median ?? 0.0, x_median_fft: features.x_median_fft ?? 0.0,
                                  x_min: features.x_min ?? 0.0, x_min_fft: features.x_min_fft ?? 0.0,
                                  x_neg_count: features.x_neg_count ?? 0.0,
                                  x_peak_count: features.x_peak_count ?? 0.0, x_peak_count_fft: features.x_peak_count_fft ?? 0.0,
                                  x_pos_count: features.x_pos_count ?? 0.0,
                                  x_skewness: features.x_skewness ?? 0.0, x_skewness_fft: features.x_skewness_fft ?? 0.0,
                                  x_std: features.x_std ?? 0.0, x_std_fft: features.x_std_fft ?? 0.0,

                                  y_IQR: features.y_IQR ?? 0.0, y_IQR_fft: features.y_IQR_fft ?? 0.0,
                                  y_aad: features.y_aad ?? 0.0, y_aad_fft: features.y_aad_fft ?? 0.0,
                                  y_above_mean: features.y_above_mean ?? 0.0, y_above_mean_fft: features.y_above_mean_fft ?? 0.0,
                                  y_energy: features.y_energy ?? 0.0, y_energy_fft: features.y_energy_fft ?? 0.0,
                                  y_kurtosis: features.y_kurtosis ?? 0.0, y_kurtosis_fft: features.y_kurtosis_fft ?? 0.0,
                                  y_mad: features.y_mad ?? 0.0, y_mad_fft: features.y_mad_fft ?? 0.0,
                                  y_max: features.y_max ?? 0.0, y_max_fft: features.y_max_fft ?? 0.0,
                                  y_maxmin_diff: features.y_maxmin_diff ?? 0.0, y_maxmin_diff_fft: features.y_maxmin_diff_fft ?? 0.0,
                                  y_mean: features.y_mean ?? 0.0, y_mean_fft: features.y_mean_fft ?? 0.0,
                                  y_median: features.y_median ?? 0.0, y_median_fft: features.y_median_fft ?? 0.0,
                                  y_min: features.y_min ?? 0.0, y_min_fft: features.y_min_fft ?? 0.0,
                                  y_neg_count: features.y_neg_count ?? 0.0,
                                  y_peak_count: features.y_peak_count ?? 0.0, y_peak_count_fft: features.y_peak_count_fft ?? 0.0,
                                  y_pos_count: features.y_pos_count ?? 0.0,
                                  y_skewness: features.y_skewness ?? 0.0, y_skewness_fft: features.y_skewness_fft ?? 0.0,
                                  y_std: features.y_std ?? 0.0, y_std_fft: features.y_std_fft ?? 0.0,

                                  z_IQR: features.z_IQR ?? 0.0, z_IQR_fft: features.z_IQR_fft ?? 0.0,
                                  z_aad: features.z_aad ?? 0.0, z_aad_fft: features.z_aad_fft ?? 0.0,
                                  z_above_mean: features.z_above_mean ?? 0.0, z_above_mean_fft: features.z_above_mean_fft ?? 0.0,
                                  z_energy: features.z_energy ?? 0.0, z_energy_fft: features.z_energy_fft ?? 0.0,
                                  z_kurtosis: features.z_kurtosis ?? 0.0, z_kurtosis_fft: features.z_kurtosis_fft ?? 0.0,
                                  z_mad: features.z_mad ?? 0.0, z_mad_fft: features.z_mad_fft ?? 0.0,
                                  z_max: features.z_max ?? 0.0, z_max_fft: features.z_max_fft ?? 0.0,
                                  z_maxmin_diff: features.z_maxmin_diff ?? 0.0, z_maxmin_diff_fft: features.z_maxmin_diff_fft ?? 0.0,
                                  z_mean: features.z_mean ?? 0.0, z_mean_fft: features.z_mean_fft ?? 0.0,
                                  z_median: features.z_median ?? 0.0, z_median_fft: features.z_median_fft ?? 0.0,
                                  z_min: features.z_min ?? 0.0, z_min_fft: features.z_min_fft ?? 0.0,
                                  z_neg_count: features.z_neg_count ?? 0.0,
                                  z_peak_count: features.z_peak_count ?? 0.0, z_peak_count_fft: features.z_peak_count_fft ?? 0.0,
                                  z_pos_count: features.z_pos_count ?? 0.0,
                                  z_skewness: features.z_skewness ?? 0.0, z_skewness_fft: features.z_skewness_fft ?? 0.0,
                                  z_std: features.z_std ?? 0.0, z_std_fft: features.z_std_fft ?? 0.0)

        (predictionProbs, prediction) = motion.modelManager.exercisesPrediction(input: input) ?? ([:], "Other")
        

    }

    // Save the prediction.
    if (motion.modelManager.selectedModel == .Exercise) {
        if ((motion.exerciseResults.last ?? "" != prediction) &&
        ((motion.exerciseResults.last ?? "" == "Other") || (prediction == "Other"))) {
            motion.exerciseResults.append(prediction)
        }
    } else {
        motion.results.append(prediction)
    }
    
    // Distribution of confidence across the different motion types in the model.
    motion.distribution.append([])
    for (_, value) in predictionProbs.sorted(by: <) {
        motion.distribution.indices.last.map{ motion.distribution[$0].append(value) }
    }
    
    // Only need to store the type of motion once each time the model is changed.
    if (motion.motionTypes.isEmpty) {
        for (key, _) in predictionProbs.sorted(by: <) {
            motion.motionTypes.append(key)
        }
    }

    // Switch from exercise model to form analysis model.
    if (motion.modelManager.selectedModel == .Exercise && prediction != "Other" &&
        motion.justWorkout && motion.exerciseResults[exist: motion.exerciseResults.count-2] ?? "" == "Other") {
        motion.results.removeAll()
        motion.modelManager.selectedModel = Model.allCases.filter { $0.rawValue == addSpaces(text: prediction) }.first ?? .Exercise
    }

    // Switch from form analysis to exercise model.
    if (motion.modelManager.selectedModel != .Exercise && prediction == "Other" &&
    motion.results.count > 1 && motion.justWorkout) {
        motion.modelManager.selectedModel = .Exercise
        
        if (motion.results.filter({ $0 != "Other" }).count == 0) {
            motion.exerciseResults.removeLast()
            motion.results.removeAll()
        }
    }
}
