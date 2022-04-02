//
//  CalcTimeLeft.swift
//  Workout Planner
//
//  Function used to calculate the estimated time completed in a workout.
//

import Foundation

func calcTimeDone(workout: WorkoutManager) -> Int {

    var timeDone: Int = 0

    // Add all exercise reps within completed sets to the total.
    if (workout.currentSet > 0) {
        for _ in 0..<workout.currentSet {
            for i in 0..<(workout.myWorkout.exercises?.count ?? 0) {
                for rep in workout.myWorkout.exerciseArray[i].repsArray {
                    timeDone += Int(workout.myWorkout.exerciseArray[i].repTime * rep.count)
                }
            }
        }
    }
    
    // Add all exercise reps within completed exercises in the current set to the total.
    if (workout.currentExercise > 0) {
        for i in 0..<workout.currentExercise {
            for rep in workout.myWorkout.exerciseArray[i].repsArray {
                timeDone += Int(workout.myWorkout.exerciseArray[i].repTime * rep.count)
            }
        }
    }
    
    // Add all exercise reps within completed exercise sets in the current exercise to the total.
    if (workout.currentExerciseSet > 0) {
        for rep in workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[0..<workout.currentExerciseSet] {
            timeDone += Int(workout.myWorkout.exerciseArray[workout.currentExercise].repTime * rep.count)
        }
    }
 
    return timeDone * 3
}
