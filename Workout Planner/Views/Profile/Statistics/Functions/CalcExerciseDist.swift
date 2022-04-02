//
//  CalcExerciseDist.swift
//  Workout Planner
//
//  Function to calculate the distribution of exercises over a given time period.
//

import Foundation

func calcExerciseDist(workoutHistories: [WorkoutHistory], since: String) -> [ChartData] {

    var chartDataSet: [ChartData] = []
    var exercises: [String: Int] = [:]
    let date = getDateSince(since: since)

    for workoutHistory in workoutHistories {
        let exercisesArray = workoutHistory.workout?.exerciseArray ?? []
        if (workoutHistory.timestamp! > date) {
            for exercise in exercisesArray {
                if (exercises[exercise.name ?? ""] != nil) {
                    if (exercise.isHold) {
                        exercises[exercise.name ?? ""]? += Int(exercise.repTime) / 2
                    } else {
                        for case let rep as Reps in exercise.reps ?? NSSet.init() {
                            exercises[exercise.name ?? ""]? += Int(rep.count)
                        }
                    }
                } else {
                    for case let rep as Reps in exercise.reps ?? NSSet.init() {
                        exercises[exercise.name ?? ""] = Int(rep.count)
                    }
                }
            }
        }
    }

    // Display the top 5 exercises if the user has done more than 5 exercises.
    if (exercises.count >= 5 ) {

        // Sorts from most reps to least and stores the top 5.
        let exercisesTop = Array(exercises).sorted(by: {$0.1 > $1.1})[0...4]

        // Sorted exercises alphabetically so they appear in a consistent order for all pie charts.
        for (exercise, reps) in exercisesTop.sorted(by: {$0.0 < $1.0}) {
            chartDataSet.append(ChartData(label: exercise, value: Double(reps)))
        }

    // Display just the exercises they have done.
    } else if (exercises.count > 0) {

        // Sort all exercises from most reps to least.
        let exercisesTop = Array(exercises).sorted(by: {$0.1 > $1.1})[0...exercises.count-1]

        // Sorted exercises alphabetically so they appear in a consistent order for all pie charts.
        for (exercise, reps) in exercisesTop.sorted(by: {$0.0 < $1.0}) {
            chartDataSet.append(ChartData(label: exercise, value: Double(reps)))
        }
    }

    return chartDataSet
}
