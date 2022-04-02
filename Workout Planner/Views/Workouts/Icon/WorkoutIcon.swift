//
//  WorkoutIcon.swift
//  Workout Planner
//
//  The icon displayed to represent an individual workout.
//

import SwiftUI

struct WorkoutIcon: View {

    @ObservedObject var workout: Workout

    var body: some View {
        VStack {

            // Icon
            WorkoutIconGrid(exercises: workout.exerciseArray, size: 100)
            
            // Workout name
            HStack {
                Text(workout.name ?? "")
                    .foregroundColor(.primary)
                    .font(.caption)
            }
            .frame(width: 100)
        }
        .padding(.leading, 15)
    }
}
