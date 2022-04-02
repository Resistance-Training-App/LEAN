//
//  StatisticsPreview.swift
//  Workout Planner
//
//  A preview of the statistics displayed on the profile view.
//

import SwiftUI
import ACarousel

struct StatisticsPreview: View {
    
    var workoutHistories: [WorkoutHistory]

    var body: some View {
        StatisticsBox(workoutHistories: workoutHistories, period: "week")
    }
}
