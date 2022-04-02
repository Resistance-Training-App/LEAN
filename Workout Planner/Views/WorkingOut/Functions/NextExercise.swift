//
//  NextExercise.swift
//  Workout Planner
//
//  Function executed when a user moves to the next exercise.
//

import Foundation

func nextExercise(workout: WorkoutManager, countdownTime: Double) {
    
    // If the exercise was timed, stop the timers.
    if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold) {
        workout.preCountdown.stop()
        workout.countdown.stop()
    }
    // If the user is on the last exercise set of the current exercise, go to the next exercise.
    if (workout.currentExerciseSet+1 == workout.myWorkout.exerciseArray[workout.currentExercise].weight?.count) {

        // Adjust the current exercise and the current set if the user was on the last exercise.
        if (workout.currentExercise < workout.myWorkout.exerciseArray.count-1) {
            workout.currentExercise += 1
        } else if (workout.currentSet < workout.myWorkout.sets-1) {
            workout.currentSet += 1
            workout.currentExercise = 0
        }
        workout.currentExerciseSet = 0
    } else {
        workout.currentExerciseSet += 1
    }
    
    // If the next exercise is also timed, start the pre-countdown if greater than 0.
    if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold) {
        if (countdownTime > 0) {
            workout.preCountdown.start(secondsElapsed: countdownTime)
        } else {
            workout.countdown.start(secondsElapsed:
                workout.myWorkout.exerciseArray[workout.currentExercise].repTime)
        }
    }
    
    // Re-calculate the estimated time left in the workout.
    workout.timeDone = calcTimeDone(workout: workout)
    workout.secondsLeft = Int(workout.myWorkout.time) - workout.timeDone
}
