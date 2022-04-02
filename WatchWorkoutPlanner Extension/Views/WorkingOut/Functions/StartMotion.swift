//
//  StartMotion.swift
//  WatchWorkoutPlanner Extension
//
//  Selects the correct classification model and starts capturing motion at 40Hz.
//

import Foundation

func startMotion(workout: WorkoutManager, motion: MotionManager) {

    // Locate the learnt exercise and assigned it as the selected model.
    if (!workout.justWorkout) {
        motion.modelManager.selectedModel = Model.allCases.filter {
            $0.rawValue == workout.myWorkout.exerciseArray[workout.currentExercise].name }.first ?? motion.modelManager.selectedModel
    } else {
        motion.modelManager.selectedModel = .Exercise
    }

    // Start capturing motion.
    motion.startUpdates()
}
