//
//  WorkingOutCountdown.swift
//  WorkingOutCountdown
//
//  Countdown displayed when a user starts a workout.
//

import SwiftUI

struct WorkingOutCountdown: View {
    
    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        
        // Countdown can be pressed to start the workout without waiting for the countdown timer to
        // finish.
        Button {
            workout.showingCountdown = false
            if (workout.warmUpArray.isEmpty) {
                workout.showingWorkoutHome = true
            } else {
                workout.showingStretchingHome = true
            }
            workout.preWorkoutCountdown.stop()
            workout.timer.restart()
        } label : {
            VStack {
                Spacer()
                
                // Workout name.
                Text(workout.myWorkout.name ?? "")
                    .font(.system(size: 60)).fontWeight(.bold)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // 3 second timer.
                ZStack {
                    CountdownBar(progress: workout.preWorkoutCountdown.secondsElapsed / 3,
                                 size: UIScreen.main.bounds.size.width * 0.8)

                    Circle()
                        .fill(colourScheme == .dark ?
                                Color(white: 0.1) :
                                Color(white: 0.9))
                        .frame(width: UIScreen.main.bounds.size.width * 0.7,
                               height: UIScreen.main.bounds.size.width * 0.7)
                    
                    Text(String(Int(workout.preWorkoutCountdown.secondsElapsed + 0.99)))
                        .font(Font.monospacedDigit(Font.system(size:
                            UIScreen.main.bounds.size.width * 0.5).weight(.bold))())
                        .foregroundColor(.primary)

                        // Start workout when countdown timer finishes.
                        .onChange(of: workout.preWorkoutCountdown.secondsElapsed, perform: { value in
                            if (workout.preWorkoutCountdown.secondsElapsed <= 0) {
                                workout.showingCountdown = false
                                if (workout.warmUpArray.isEmpty) {
                                    workout.showingWorkoutHome = true
                                } else {
                                    workout.showingStretchingHome = true
                                }
                                workout.preWorkoutCountdown.stop()
                                workout.timer.restart()
                            }
                        })
                }
                Spacer()
            }
        }
    }
}
