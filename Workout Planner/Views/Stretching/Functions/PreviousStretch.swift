//
//  PreviousStretch.swift
//  PreviousStretch
//
//  Function executed when a user moves to the previous stretch.
//

import Foundation

func previousStretch(workout: WorkoutManager, stretches: [Stretch], countdownTime: Double) {

    workout.preCountdown.stop()
    workout.countdown.stop()
    
    // Adjust the current stretch.
    if (workout.currentStretch > 0) {
        workout.currentStretch -= 1
    }
    
    // Start the pre-countdown for the previous stretch if greater than 0.
    if (countdownTime > 0) {
        workout.preCountdown.start(secondsElapsed: countdownTime)
    } else {
        workout.countdown.start(secondsElapsed:
            workout.myWorkout.stretchArray[workout.currentStretch].repTime)
    }
}
