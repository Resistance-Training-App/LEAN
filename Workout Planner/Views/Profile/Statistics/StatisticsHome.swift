//
//  StatisticsHome.swift
//  Workout Planner
//
//  Displays statistics based on workouts completed by the user.
//

import SwiftUI
import ACarousel

struct StatisticsHome: View {
    
    @EnvironmentObject var profile: Profile
    
    var workoutHistories: [WorkoutHistory]

    let periods: [String] = ["week", "month", "year"]
    
    var body: some View {
        ScrollView {
            
            // A carousel of pie charts based on workouts from the last week, month and year.
            ACarousel(periods, id: \.self) { period in
                StatisticsBox(workoutHistories: workoutHistories, period: period)
            }
            .frame(minHeight: 600)

            // Statistics based on all workouts completed.
            StatisticsAllTime(workoutHistories: workoutHistories)
            
            // Personal best weights for each exercise completed in a workout.
            if profile.personalBestArray.filter{ $0.weight > 0 }.count > 0 {
                StatisticsPBs(workoutHistories: workoutHistories)
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}
