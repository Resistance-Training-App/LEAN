//
//  WorkoutSummaryDone.swift
//  Workout Planner
//
//  Floating button at the bottom of workout summary to return to the workout detail page.
//

import SwiftUI

struct WorkoutSummaryDone: View {
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {

        // Hide the summary view and reset the workout object's attributes.
        Button {
            workout.showingSummaryView = false
            workout.resetWorkout()
        } label: {
            Text("Done")
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .frame(width: 80, height: 40)
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 30)
    }
}
