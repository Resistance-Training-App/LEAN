//
//  WorkoutListView.swift
//  WorkoutListView
//
//  A workout row displayed in the workout list.
//

import SwiftUI

struct WorkoutListRow: View {
    
    @ObservedObject var myWorkout: Workout
    
    var body: some View {
        HStack {
            
            // Workout icon.
            WorkoutIcon(exercises: myWorkout.exercises?.sortedArray(using:
                [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)]) as! [Exercise],
                        size: 50)
            
            VStack(alignment: .leading) {
                
                // Workout name
                Text(myWorkout.name ?? "")
                    .foregroundColor(.primary)
                    .padding(.leading, 5)
                    .font(Font.body.bold())
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                // Estimate of the type of workout based on the exercises it includes.
                Text(myWorkout.category ?? "" == "All" ? "All Body" : myWorkout.category ?? "")
                    .font(.caption2)
                    .padding(.leading, 5)
                
                HStack {
                    VStack {

                        // Estimate of the time the workout will take.
                        Text(String(formatSeconds(seconds: Int(myWorkout.time))))
                            .font(.caption2)
                            .padding(.leading, 5)
                    }
                    Spacer()
                    
                    // Display a start if the workout is a favourite
                    if (myWorkout.isFavourite) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Spacer()
        }
        .padding(.leading, -3.5)
    }
}
