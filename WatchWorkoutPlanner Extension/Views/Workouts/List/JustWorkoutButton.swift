//
//  JustWorkoutButton.swift
//  WatchWorkoutPlanner Extension
//
//  Button to start an open workout.
//

import SwiftUI

struct JustWorkoutButton: View {

    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile

    var body: some View {
        NavigationLink(destination: WorkingOutCountdown().environmentObject(profile),
                       isActive: $workout.showingCountdown)
        {
            HStack {
                Spacer()
                Image(systemName: "play.circle")
                    .font(Font.body.bold())
                Text("Just workout")
                    .font(Font.body.bold())
                Spacer()
            }
        }
        .foregroundColor(.white)
        .buttonStyle(.borderedProminent)
        .simultaneousGesture(TapGesture().onEnded {
            workout.justWorkout = true
            motion.justWorkout = true
            workout.startWorkout()
        })
        .listRowBackground(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.accentColor))
        .cornerRadius(10)
    }
}

