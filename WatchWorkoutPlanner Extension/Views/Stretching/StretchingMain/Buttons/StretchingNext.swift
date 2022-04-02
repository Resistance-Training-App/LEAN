//
//  StretchingNext.swift
//  StretchingNext
//

import SwiftUI

struct StretchingNext: View {

    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        ZStack {

            // Start workout button if it's the last stretch in the warm-up.
            if (workout.currentStretch == stretches.count-1 && workout.stretchPeriod == .warmUp) {
                Button(action: {
                    workout.countdown.stop()
                    workout.preCountdown.stop()
                    workout.currentStretch = 0
                    workout.showingStretchingHome = false
                    workout.showingWorkoutHome = true
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                
            // End workout button if it's the last stretch in the cooldown.
            } else if (workout.currentStretch == stretches.count-1 && workout.stretchPeriod == .coolDown) {
                Button {
                    workout.endWorkout()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)

            // Next stretch button.
            } else {
                Button(action: {
                    nextStretch(workout: workout,
                                stretches: stretches,
                                countdownTime: profile.countdown)
                }) {
                    Image(systemName: "arrow.forward.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .disabled(workout.mode == .running ? false : true)
            }
        }
        .padding(.trailing)
    }
}
