//
//  WorkingOutSecondary.swift
//  WorkingOutSecondary
//
//  The secondary view displayed when working out having less important information and controls.
//

import SwiftUI

struct WorkingOutSecondary: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            HStack {

                // Play/pause the workout.
                PlayPause()
                
                // Exit the workout early, discarding the workout if exited in less than 10 seconds.
                Exit(showingAlert: $showingAlert)
            }

            // Displays the exercise and set progress in the current workout using dots.
            if (!workout.justWorkout) {
                WorkingOutSecondaryDetails()
                    .padding(.bottom)
                Divider()

                // A list of exercises in the current workout.
                ForEach(0..<workout.myWorkout.exerciseArray.count, id: \.self) { i in
                    WorkoutExerciseRow(exercise: workout.myWorkout.exerciseArray[i])
                }
            } else {
                
                //  Allows the user to select the weight during an open workout.
                WorkingOutSecondaryWeight()
            }
        }
    }
}
