//
//  WorkingOutControls.swift
//  Workout Planner
//
//  Buttons to control the workout found at the bottom of the screen for easy one-handed use.
//

import SwiftUI

struct WorkingOutControls: View {
        
    @EnvironmentObject var workout: WorkoutManager

    @State var showingAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {

                // Return to the previous exercise.
                WorkingOutPrevious()
                Spacer()
                
                // Plays/pauses the workout based on the current play/pause status of the workout.
                WorkingOutPlayPause()
                Spacer()
                
                // Go to the next exercise.
                WorkingOutNext()
            }
            .padding(.leading)

            // Exit the entire workout early.
            WorkingOutExit(showingAlert: $showingAlert)
        }
    }
}
