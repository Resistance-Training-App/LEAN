//
//  WorkingOutHeader.swift
//  Workout Planner
//
//  Progress and other numbers displayed at the top of the screen while working out.
//

import SwiftUI

struct WorkingOutHeader: View {

    @EnvironmentObject var workout: WorkoutManager
    
    // Returns the overall progress through the workout as a number between 0 and 1 to be later
    // converted to a percentage.
    private var progress: Double {

        // Prevents a divide by 0 error
        guard workout.myWorkout.time > 0 else { return 1 }

        return Double(workout.timeDone) / Double(workout.myWorkout.time)
    }

    var body: some View {
        VStack {

            // The top of the header including the time and estimated minutes remaining.
            WorkingOutHeaderTop(progress: progress)

            // Progress bar showing the overall progress through this workout.
            ProgressBar(progress: progress)
                .frame(height: 20)
            
            // Shows the user which set and exercise they are currently on.
            WorkingOutHeaderBottom()
        }
        .padding([.leading, .trailing])
    }
}
