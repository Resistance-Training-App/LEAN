//
//  StretchingPrevious.swift
//  Workout Planner
//
//  Button to return to the previous stretch or reset the workout timer if they are already on the
//  first stretch of the warm-up.
//

import SwiftUI

struct StretchingPrevious: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        ZStack {

            // Restart button
            if (workout.currentStretch == 0) {
                Button {
                    workout.restartWorkout(countdownTime: profile.countdown)
                } label: {
                    Text("Restart")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                
            // Previous stretch button.
            } else {
                Button {
                    previousStretch(workout: workout,
                                    stretches: stretches,
                                    countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled(workout.mode == .running ? false : true)
            }
        }
    }
}
