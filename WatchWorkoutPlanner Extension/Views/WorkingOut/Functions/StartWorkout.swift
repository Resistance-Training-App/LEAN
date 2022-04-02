//
//  StartWorkout.swift
//  WatchWorkoutPlanner Extension
//
//  Function to start the workout once the countdown has finished or has been pressed.
//

import Foundation

func startWorkout(workout: WorkoutManager, motion: MotionManager) {

    // Show stretching view if there's a warm-up, otherwise show the main working out view.
    if (workout.warmUpArray.isEmpty) {
        workout.showingWorkoutHome = true
    } else {
        workout.showingStretchingHome = true
    }

    // Start the workout timer.
    workout.startTimer()
    workout.preWorkoutCountdown.stop()

    // Start recording motion.
    if (!workout.justWorkout) {
        if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
            startMotion(workout: workout, motion: motion)
        }
    } else {
        startMotion(workout: workout, motion: motion)
    }
}
