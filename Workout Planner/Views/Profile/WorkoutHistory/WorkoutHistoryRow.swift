//
//  WorkoutHistoryRow.swift
//  Workout Planner
//
//  A row for each workout in the workout history list.
//

import SwiftUI

struct WorkoutHistoryRow: View {
    
    @Environment(\.colorScheme) var colourScheme

    var workoutHistory: WorkoutHistory

    var body: some View {
        ZStack {
            HStack {
                WorkoutIconGrid(exercises: workoutHistory.workout?.exerciseArray ?? [], size: 80)
                
                VStack(alignment: .leading) {

                    // Workout name.
                    Text(workoutHistory.workout?.name ?? "")
                        .foregroundColor(.primary)
                        .bold()

                    // Estimate of the type of workout based on the exercises it includes.
                    Text(workoutHistory.workout?.category ?? "" == "All" ? "All Body" :
                         workoutHistory.workout?.category ?? "")
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    // The time taken to complete the workout.
                    Text(formatSeconds(seconds: Int(workoutHistory.time)))
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    // Display which device the workout was run on.
                    if (workoutHistory.avgHeartRate > 0) {
                        Image(systemName: "applewatch")
                    } else {
                        Image(systemName: "iphone")
                    }
                }
                Spacer()
            }
            .padding([.top, .bottom], 10)
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    // Timestamp the workout was completed.
                    Text(formatDate(date: workoutHistory.timestamp ?? Date()))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
            }
        }
    }
}
