//
//  WorkoutListRow.swift
//  Workout Planner
//
//  A row representing a workout in the workout list.
//

import SwiftUI

struct WorkoutListRow: View {
    
    @ObservedObject var workout: Workout

    var body: some View {
        
        // Displays the icon, name, category and estimated time of the workout.
        HStack {
            
            // Icon
            WorkoutIconGrid(exercises: workout.exerciseArray, size: 80)

                VStack(alignment: .leading) {
                    
                    // Workout name.
                    Text(workout.name ?? "")
                        .foregroundColor(.primary)
                        .padding(.leading, 10)
                        .font(Font.body.bold())
                    
                    // Estimate of the type of workout based on the exercises it includes.
                    Text(workout.category ?? "" == "All" ? "All Body" : workout.category ?? "")
                        .font(.caption)
                        .padding(.leading, 10)
                    
                    // Estimate for the time it will take to complete the workout.
                    Text(formatSeconds(seconds: Int(workout.time)))
                        .font(.caption)
                        .padding(.leading, 10)

                }
            Spacer()
            
            // Display a star if the workout had been added to the favourites.
            if workout.isFavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
