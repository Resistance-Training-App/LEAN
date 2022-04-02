//
//  CancelWorkoutCreation.swift
//  Workout Planner
//
//  Cancels the creation of a new workout when the user presses 'Cancel'.
//

import Foundation
import CoreData

func cancelWorkoutCreation(showNewWorkout: inout Bool,
                           newWorkoutData: inout Workout.Template,
                           exercises: [Exercise],
                           viewContext: NSManagedObjectContext) {
    showNewWorkout = false
    newWorkoutData = Workout.Template()

    // Delete all exercises that were created before the user cancelled
    // the workout creation.
    for exercise in exercises {
        if (exercise.workout == nil && exercise.reps?.count != 0) {
            viewContext.delete(exercise)
        }
    }

    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()
}
