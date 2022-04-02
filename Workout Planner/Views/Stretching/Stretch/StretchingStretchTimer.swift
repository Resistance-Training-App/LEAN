//
//  StretchingStretchTimer.swift
//  StretchingStretchTimer
//
//  Stretch pre-countdown (3...2...1) and countdown for each stretch in the warm-up/cooldown.
//

import SwiftUI

struct StretchingStretchTimer: View {
    
    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        ZStack {

            // Show countdown when the stretching starts.
            if (workout.countdown.mode != .stopped) {
                
                ZStack {
                    CountdownBar(progress: workout.countdown.secondsElapsed /
                                 (stretches[workout.currentStretch].repTime),
                                 size: 180)

                    Circle()
                        .fill(colourScheme == .dark ?
                                Color(white: 0.1) :
                                Color(white: 0.9))
                        .frame(width: 150, height: 150)
                    
                    Text(String(Int(workout.countdown.secondsElapsed + 0.9)))
                        .font(Font.monospacedDigit(Font.system(size: 100).weight(.bold))())
                }
                .frame(maxWidth: .infinity, maxHeight: 180)

                    // Keep checking to see if the countdown has finished. Start the workout if it
                    // was the last stretch in the warm-up. End the workout if it was the last
                    // stretch in the cooldown. Otherwise move onto the next exercise.
                    .onChange(of: workout.countdown.secondsElapsed, perform: { value in
                        if (workout.countdown.secondsElapsed <= 0.2) {
                            workout.countdown.stop()
                            
                            if (workout.currentStretch == stretches.count-1 &&
                            workout.stretchPeriod == .warmUp) {
                                workout.showingStretchingHome = false
                                workout.showingWorkoutHome = true
                            } else if (workout.currentStretch == stretches.count-1 &&
                            workout.stretchPeriod == .coolDown) {
                                workout.endWorkout()
                            } else {
                                nextStretch(workout: workout,
                                            stretches: stretches,
                                            countdownTime: profile.countdown)
                            }
                        }
                    })
                
            // Show pre-countdown timer allowing the user to prepare for the stretch.
            } else if (workout.preCountdown.mode != .stopped) {

                // Displays the number of the countdown.
                Text(String(Int(workout.preCountdown.secondsElapsed + 0.9)))
                    .font(Font.monospacedDigit(Font.system(size: 140).weight(.bold))())
                    .frame(maxWidth: .infinity, maxHeight: 180)

                    // Keep checking to see if either countdown has stopped to either move onto the
                    // next countdown or continue to the next stretch.
                    .onChange(of: workout.preCountdown.secondsElapsed, perform: { value in
                        if (workout.preCountdown.secondsElapsed <= 0.2) {
                            workout.preCountdown.stop()
                            workout.countdown.start(secondsElapsed:
                                                        stretches[workout.currentStretch].repTime)
                        }
                    })
            
            // Placeholder to prevent other elements on screen from moving before a countdown has
            // started.
            } else {
                Text("")
                    .frame(width: UIScreen.main.bounds.size.width, height: 180)
            }
        }
        .onAppear {
            if (workout.currentStretch == 0) {
                if (profile.countdown > 0) {
                    workout.preCountdown.start(secondsElapsed: profile.countdown)
                } else {
                    workout.countdown.start(secondsElapsed:
                        workout.myWorkout.stretchArray[workout.currentStretch].repTime)
                }
            }
        }
    }
}
