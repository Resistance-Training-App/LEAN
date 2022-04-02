//
//  WorkingOutPrevious.swift
//  WorkingOutPrevious
//
//  Navigate to the previous exercise or restart the workout if the user is on the first exercise of
//  the workout.
//

import SwiftUI

struct WorkingOutPrevious: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        ZStack {

            // Previous exercise button.
            Button {
                previousExercise(workout: workout, motion: motion, countdownTime: profile.countdown)
            } label: {
                Image(systemName: "arrow.backward.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.white)

            // Button disabled if the user is on the first exercise set of the workout.
            .disabled(workout.mode == .running && (workout.currentExercise != 0 ||
                      workout.currentSet != 0 || workout.currentExerciseSet != 0) ? false : true)

        }
        .padding(.leading)
    }
}
