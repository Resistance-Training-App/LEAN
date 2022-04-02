//
//  StatisticFeatures.swift
//  Form Identifier
//
//  Extracts statistical features from motion which are input to the model.
//

struct StatisticFeatures {

    var x_mean: Double?; var y_mean: Double?; var z_mean: Double?;
    var x_std: Double?; var y_std: Double?; var z_std: Double?;
    var x_aad: Double?; var y_aad: Double?; var z_aad: Double?;
    var x_min: Double?; var y_min: Double?; var z_min: Double?;
    var x_max: Double?; var y_max: Double?; var z_max: Double?;
    var x_maxmin_diff: Double?; var y_maxmin_diff: Double?; var z_maxmin_diff: Double?;
    var x_median: Double?; var y_median: Double?; var z_median: Double?;
    var x_mad: Double?; var y_mad: Double?; var z_mad: Double?;
    var x_IQR: Double?; var y_IQR: Double?; var z_IQR: Double?;
    var x_neg_count: Double?; var y_neg_count: Double?; var z_neg_count: Double?;
    var x_pos_count: Double?; var y_pos_count: Double?; var z_pos_count: Double?;
    var x_above_mean: Double?; var y_above_mean: Double?; var z_above_mean: Double?;
    var x_peak_count: Double?; var y_peak_count: Double?; var z_peak_count: Double?;
    var x_skewness: Double?; var y_skewness: Double?; var z_skewness: Double?;
    var x_kurtosis: Double?; var y_kurtosis: Double?; var z_kurtosis: Double?;
    var x_energy: Double?; var y_energy: Double?; var z_energy: Double?;
    var avg_result_accl: Double?
    var sma: Double?

    var x_mean_fft: Double?; var y_mean_fft: Double?; var z_mean_fft: Double?;
    var x_std_fft: Double?; var y_std_fft: Double?; var z_std_fft: Double?;
    var x_aad_fft: Double?; var y_aad_fft: Double?; var z_aad_fft: Double?;
    var x_min_fft: Double?; var y_min_fft: Double?; var z_min_fft: Double?;
    var x_max_fft: Double?; var y_max_fft: Double?; var z_max_fft: Double?;
    var x_maxmin_diff_fft: Double?; var y_maxmin_diff_fft: Double?; var z_maxmin_diff_fft: Double?;
    var x_median_fft: Double?; var y_median_fft: Double?; var z_median_fft: Double?;
    var x_mad_fft: Double?; var y_mad_fft: Double?; var z_mad_fft: Double?;
    var x_IQR_fft: Double?; var y_IQR_fft: Double?; var z_IQR_fft: Double?;
    var x_above_mean_fft: Double?; var y_above_mean_fft: Double?; var z_above_mean_fft: Double?;
    var x_peak_count_fft: Double?; var y_peak_count_fft: Double?; var z_peak_count_fft: Double?;
    var x_skewness_fft: Double?; var y_skewness_fft: Double?; var z_skewness_fft: Double?;
    var x_kurtosis_fft: Double?; var y_kurtosis_fft: Double?; var z_kurtosis_fft: Double?;
    var x_energy_fft: Double?; var y_energy_fft: Double?; var z_energy_fft: Double?;
    var avg_result_accl_fft: Double?
    var sma_fft: Double?
}
