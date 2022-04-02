//
//  RemoveWorkoutHistory.swift
//  Workout Planner
//
//  Function to remove a workout history (a record of a completed workout including metrics).
//

import Foundation
import CoreData

func removeWorkoutHistory(workoutHistory: WorkoutHistory,
                          profile: Profile,
                          viewContext: NSManagedObjectContext) {
    
    // Calculate the number of reps completed in the workout.
    var total_reps: Int64 = 0
    for exercise in workoutHistory.workout?.exerciseArray ?? [] {
        for case let rep as Reps in exercise.reps ?? NSSet.init() {
            total_reps += Int64(rep.count)
        }
    }
    
    // Update statistics.
    profile.statistics?.workouts -= 1
    profile.statistics?.time -= workoutHistory.time
    profile.statistics?.reps -= total_reps
    
    // Delete workout history.
    viewContext.delete(workoutHistory)

    // Save context.
    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
