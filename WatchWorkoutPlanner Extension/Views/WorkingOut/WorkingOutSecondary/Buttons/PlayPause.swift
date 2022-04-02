//
//  PlayPause.swift
//  PlayPause
//
//  Button to play/pause the workout.
//

import SwiftUI

struct PlayPause: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    
    var body: some View {
        if (workout.mode == .paused) {
            Button {
                workout.resume()
                
                if (!workout.justWorkout) {
                
                    // Resume motion if the current exercise is learnt.
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
                        motion.startUpdates()
                    }

                    // Pause the timers if the current exercise is a hold.
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold ||
                        workout.showingStretchingHome) {
                        if (workout.preCountdown.mode == .paused) {
                            workout.preCountdown.restart(secondsElapsed: workout.preCountdown.secondsElapsed)
                        } else if (workout.countdown.mode == .paused) {
                            workout.countdown.restart(secondsElapsed: workout.countdown.secondsElapsed)
                        }
                    }
                } else {
                    motion.startUpdates()
                }
            } label: {
                Image(systemName: "play.fill")
            }
            .tint(.green)
        } else {
            Button {
                workout.pause()
                
                if (!workout.justWorkout) {

                    // Pause motion if the current exercise is learnt.
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
                        motion.pauseUpdates()
                    }

                    // Resume the timers if the current exercise is a hold.
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold ||
                        workout.showingStretchingHome) {
                        if (workout.preCountdown.mode == .running) {
                            workout.preCountdown.pause()
                        } else if (workout.countdown.mode == .running) {
                            workout.countdown.pause()
                        }
                    }
                } else {
                    motion.pauseUpdates()
                }
            } label: {
                Image(systemName: "pause.fill")
            }
            .tint(.green)
        }
    }
}
