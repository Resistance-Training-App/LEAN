//
//  WorkoutHistoryExerciseSummaryBox.swift
//  Workout Planner
//
//  Displays the exercise metrics of a specific exercise set.
//

import SwiftUI

struct WorkoutHistoryExerciseSummaryBox: View {

    @Environment(\.colorScheme) var colourScheme
    @EnvironmentObject var profile: Profile
    
    let exercise: Exercise
    let index: Int
    var isJustWorkout: Bool?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                // Weight of set.
                WorkoutSummaryBoxRow(name: "Weight",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(format: exercise.weightArray[index].count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f",
                                                   exercise.weightArray[index].count),
                                     unit: " \(profile.weightUnit ?? "")")
                
                // Reps counted and rep target.
                if (isJustWorkout ?? false) {
                    WorkoutSummaryBoxRow(name: "Reps",
                                         colour: colourScheme == .dark ?
                                                 Color(white: 0.9) :
                                                 Color(white: 0.1),
                                         value: String(Int(exercise.repsArray[index].count)))
                } else {
                    WorkoutSummaryBoxRow(name: "Reps",
                                         colour: exercise.metricsArray[index].repCount >= Int(exercise.repsArray[index].count) ?
                                                Color(.green) :
                                                Color(.red),
                                         value: String("\(exercise.metricsArray[index].repCount)/\(Int(exercise.repsArray[index].count))"))
                }
            }
            Divider()
            HStack {

                // Average rep time
                WorkoutSummaryBoxRow(name: "Avg. Rep Time",
                                     colour: .orange,
                                     value: String(format: "%.1f",
                                                   calcAverageRepTime(repStartTimes: exercise.metricsArray[index].repStartTimes ?? [],
                                                                      repEndTimes: exercise.metricsArray[index].repEndTimes ?? [])),
                                     unit: "s")
                                    
                // Average deviation of rep times
                WorkoutSummaryBoxRow(name: "Rep Time Consistency",
                                     colour: .orange,
                                     value: String(format: "%.0f",
                                                   averageDeviation(numbers: zip(exercise.metricsArray[index].repEndTimes ?? [],
                                                                                 exercise.metricsArray[index].repStartTimes ?? []).map(-))),
                                     unit: "%")
            }
            Divider()
            if (exercise.isRotation) {
                HStack {
                                        
                    // Average range of motion
                    WorkoutSummaryBoxRow(name: "Avg. Range of Motion",
                                         colour: .blue,
                                         value: String(format: "%.0f",
                                                       calcAverageRangeOfMotion(repRangeOfMotions: exercise.metricsArray[index].repRangeOfMotions ?? [])),
                                         unit: "\u{00B0}")
                    
                    // Average deviation of range of motions
                    WorkoutSummaryBoxRow(name: "Range of Motion Consistency",
                                         colour: .blue,
                                         value: String(format: "%.0f",
                                                       averageDeviation(numbers: exercise.metricsArray[index].repRangeOfMotions ?? [])),
                                         unit: "%")
                }
                Divider()
            }
            HStack {
                
                // Total time passed during the exercise set.
                WorkoutSummaryBoxRow(name: "Total Set Time",
                                     colour: .pink,
                                     value: String(format: "%.1f", (exercise.metricsArray[index].repEndTimes?.last ?? 0) -
                                                                   (exercise.metricsArray[index].repStartTimes?.first ?? 0)),
                                     unit: "s")

                // Exercising to resting ratio.
                WorkoutSummaryBoxRow(name: "Exercising Time",
                                     colour: .pink,
                                     value: String(format: "%.0f", findExercisingPercentage(results:
                                            exercise.metricsArray[index].results ?? [])),
                                     unit: "%")
            }
            Divider()
            HStack {
                
                // The proportion of time spent in eccentric movement.
                WorkoutSummaryBoxRow(name: "Eccentric Ratio",
                                     colour: .yellow,
                                     value: String(format: "%.1f",
                                       calcEccentricConcentricRatio(repStartTimes: exercise.metricsArray[index].repStartTimes ?? [],
                                                                                   repMiddleTimes: exercise.metricsArray[index].repMiddleTimes ?? [],
                                                                                   repEndTimes: exercise.metricsArray[index].repEndTimes ?? [],
                                                                                   isEccentric: true)),
                                     unit: "%")

                // The proportion of time spent in concentric movement.
                WorkoutSummaryBoxRow(name: "Concentric Ratio",
                                     colour: .yellow,
                                     value: String(format: "%.1f",
                                       calcEccentricConcentricRatio(repStartTimes: exercise.metricsArray[index].repStartTimes ?? [],
                                                                                   repMiddleTimes: exercise.metricsArray[index].repMiddleTimes ?? [],
                                                                                   repEndTimes: exercise.metricsArray[index].repEndTimes ?? [],
                                                                                   isEccentric: false)),
                                     unit: "%")
            }
        }
        .padding(.top)
    }
}
