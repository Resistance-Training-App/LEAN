//
//  StretchingNext.swift
//  Workout Planner
//
//  Button to either start the workout if they were in the warm-up, end the workout if they were in
//  the cooldown, or go to the next stretch if they are in the middle of a warm-up/cooldown.
//

import SwiftUI

struct StretchingNext: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        ZStack {

            // Start workout button.
            if (workout.currentStretch == stretches.count-1 && workout.stretchPeriod == .warmUp) {
                Button {
                    workout.countdown.stop()
                    workout.preCountdown.stop()
                    workout.currentStretch = 0
                    workout.showingStretchingHome = false
                    workout.showingWorkoutHome = true
                } label: {
                    Text("Start\nWorkout")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 50)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, -10)

            // End workout button.
            } else if (workout.currentStretch == stretches.count-1 && workout.stretchPeriod == .coolDown) {
                Button {
                    workout.endWorkout()
                } label: {
                    Text("Finish")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                
            // Next stretch button.
            } else {
                Button {
                    nextStretch(workout: workout,
                                stretches: stretches,
                                countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled(workout.mode == .running ? false : true)
            }
        }
        .padding(.trailing)
    }
}
