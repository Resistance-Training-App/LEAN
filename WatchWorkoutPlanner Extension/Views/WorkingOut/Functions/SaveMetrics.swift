//
//  SaveMetrics.swift
//  WatchWorkoutPlanner Extension
//
//  Saves the motion metrics for a specific exercise and set.
//

import Foundation
import CoreData

func saveMetrics(workout: WorkoutManager,
                 motion: MotionManager,
                 viewContext: NSManagedObjectContext) {

    // Create a new metrics object if it doesn't already exist for this exercise and set.
    if ((motion.metrics[exist: workout.currentExercise]) != nil) {
        if (motion.metrics[workout.currentExercise][exist: workout.currentExerciseSet] == nil) {
            motion.metrics[workout.currentExercise].append(Metrics.init(context: viewContext))
        }
    } else {
        motion.metrics.append([Metrics.init(context: viewContext)])
    }

    // Assign metric attributes.
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].repCount = Int64(motion.repCount)
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].order = Int64(workout.currentExerciseSet)
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].results = motion.results
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].repStartTimes = motion.repStartTimes
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].repMiddleTimes = motion.repMiddleTimes
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].repEndTimes = motion.repEndTimes
    motion.metrics[workout.currentExercise][workout.currentExerciseSet].repRangeOfMotions = motion.repRangeOfMotions

    // Remove duplicated metrics data ready for the next exercise.
    motion.clearResults()

    // Save.
    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
