//
//  NextStretch.swift
//  NextStretch
//
//  Function executed when a user moves to the next stretch.
//

import Foundation

func nextStretch(workout: WorkoutManager, stretches: [Stretch], countdownTime: Double) {
    
    workout.preCountdown.stop()
    workout.countdown.stop()

    // Adjust the current stretch.
    if (workout.currentStretch < stretches.count-1) {
        workout.currentStretch += 1
    }
    
    // Start the pre-countdown for the next stretch if greater than 0.
    if (countdownTime > 0) {
        workout.preCountdown.start(secondsElapsed: countdownTime)
    } else {
        workout.countdown.start(secondsElapsed:
            workout.myWorkout.stretchArray[workout.currentStretch].repTime)
    }
}
