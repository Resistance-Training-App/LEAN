//
//  StatisticsAllTime.swift
//  Workout Planner
//
//  A box of statistics across all workouts completed.
//

import SwiftUI

struct StatisticsAllTime: View {

    @Environment(\.colorScheme) var colourScheme
    @EnvironmentObject var profile: Profile
    
    var workoutHistories: [WorkoutHistory]

    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(colourScheme == .dark ?
                        Color(white: 0.1) :
                        Color(white: 0.9))
                .frame(maxWidth: .infinity, minHeight: 220)
        
            VStack(spacing: 15) {
                Text("All Time")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                
                // Number of workouts completed.
                StatisticsBoxRow(name: "Workouts Completed",
                                 number: String(profile.statistics?.workouts ?? 0))

                // Time spent completing workouts.
                StatisticsBoxRow(name: "Time",
                                 number: formatSeconds(seconds: Int(profile.statistics?.time ?? 0)))
                
                // Number of reps completed.
                StatisticsBoxRow(name: "Reps",
                                 number: String(profile.statistics?.reps ?? 0))
                
                // Longest workout completed in terms of time.
                StatisticsBoxRow(name: "Longest Workout",
                                 number: String(formatSeconds(seconds: Int(profile.statistics?.longestWorkout ?? 0))))
                
            }
            .frame(maxWidth: .infinity, minHeight: 220)
        }
        .padding([.top, .leading, .trailing])
    }
}
