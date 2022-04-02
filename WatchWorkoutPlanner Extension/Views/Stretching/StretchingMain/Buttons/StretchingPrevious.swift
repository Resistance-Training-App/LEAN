//
//  StretchingPrevious.swift
//  StretchingPrevious
//
//  Navigate to the previous stretch or restart the warm-up/cooldown if the user is on the first
//  stretch of the warm-up/cooldown.
//

import SwiftUI

struct StretchingPrevious: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        ZStack {

            // Restart button if it's the first stretch in the warm-up.
            if (workout.currentStretch == 0) {
                Button {
                    workout.restartWorkout(countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                
            // Previous stretch button.
            } else {
                Button {
                    previousStretch(workout: workout,
                                    stretches: stretches,
                                    countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.backward.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .disabled(workout.mode == .running && workout.currentStretch != 0 ? false : true)
            }
        }
        .padding(.leading)
    }
}
