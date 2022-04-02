//
//  CalcCategoryDist.swift
//  Workout Planner
//
//  Function to calculate the distribution of exercise categories over a given time period.
//

import Foundation

func calcCategoryDist(workoutHistories: [WorkoutHistory], since: String) -> [ChartData] {

    var chartDataSet: [ChartData] = []
    var exercises: [String: Int] = [:]
    let date = getDateSince(since: since)

    for workoutHistory in workoutHistories {
        let exercisesArray = workoutHistory.workout?.exerciseArray ?? []
        if (workoutHistory.timestamp! > date) {
            for exercise in exercisesArray {
                if (exercises[exercise.category ?? ""] != nil) {
                    if (exercise.isHold) {
                        exercises[exercise.category ?? ""]! += Int(exercise.repTime) / 2
                    } else {
                        for case let rep as Reps in exercise.reps ?? NSSet.init() {
                            exercises[exercise.category ?? ""]! += Int(rep.count)
                        }
                    }
                } else {
                    for case let rep as Reps in exercise.reps ?? NSSet.init() {
                        exercises[exercise.category ?? ""] = Int(rep.count)
                    }
                }
            }
        }
    }

    chartDataSet.append(ChartData(label: "Upper Body", value: Double(exercises["Upper Body"] ?? 0)))
    chartDataSet.append(ChartData(label: "Core", value: Double(exercises["Core"] ?? 0)))
    chartDataSet.append(ChartData(label: "Lower Body", value: Double(exercises["Lower Body"] ?? 0)))

    return chartDataSet
}
