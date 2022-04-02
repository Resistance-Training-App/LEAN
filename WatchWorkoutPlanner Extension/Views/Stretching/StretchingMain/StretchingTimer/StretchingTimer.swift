//
//  StretchingTimer.swift
//  StretchingTimer
//
//  Timer displayed for each stretch in a warm-up/cooldown.
//

import SwiftUI

struct StretchingTimer: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    let stretches: [Stretch]
    
    var body: some View {
        TimelineView(NumbersTimelineSchedule(from: workout.builder?.startDate ?? Date())) { context in
            ZStack {
                
                // Background
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.1))
                    .frame(maxWidth: .infinity, maxHeight: 30)
                
                // Show countdown circle progress bar only if it's currently displaying the countdown.
                if (workout.preCountdown.mode == .stopped) {
                    ProgressBar(progress: workout.countdown.secondsElapsed /
                                          stretches[workout.currentStretch].repTime)
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }

                // Displays the number of the countdown.
                Text(String(Int(workout.preCountdown.mode != .stopped ?
                                workout.preCountdown.secondsElapsed + 0.9 :
                                workout.countdown.secondsElapsed + 0.9)))
                    .font(Font.bold(Font.system(size: 30))())
                    .frame(width: 50, height: 25, alignment: .center)
                    .padding(.bottom, 1)
                
                    // Keep checking to see if either countdown has stopped to either move onto the
                    // next countdown or continue to the next stretch.
                    .onChange(of: workout.preCountdown.mode == .running ?
                                  workout.preCountdown.secondsElapsed :
                                  workout.countdown.secondsElapsed,
                              perform: { value in
                        if (workout.preCountdown.mode != .stopped) {
                            if (workout.preCountdown.secondsElapsed <= 0.1) {
                                workout.preCountdown.stop()
                                workout.countdown.start(secondsElapsed:
                                                        stretches[workout.currentStretch].repTime)
                            }
                        } else {
                            if (workout.countdown.mode != .stopped) {
                                if (workout.countdown.secondsElapsed <= 0.1) {
                                    workout.countdown.stop()
                                    
                                    // Play haptic feedback to let the user know the stretch has
                                    // finished (the user may be in a position such that they
                                    // cannot see the Apple Watch display).
                                    WKInterfaceDevice.current().play(.success)

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
                            }
                        }
                    })
            }
        }
    }
}
