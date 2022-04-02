//
//  WorkoutSummaryHistoryBox.swift
//  Workout Planner
//
//  Box of statistics displayed at the top of the workout summary view.
//

import SwiftUI

struct WorkoutHistorySummaryBox: View {

    @Environment(\.colorScheme) var colourScheme
    
    var time: Double
    var workoutHistory: WorkoutHistory

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                // Time taken to complete workout.
                WorkoutSummaryBoxRow(name: "Time",
                                     colour: .green,
                                     value: String(formatSeconds(seconds: Int(time))))

                // Number of exercises in each set.
                WorkoutSummaryBoxRow(name: "Total Exercises",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(workoutHistory.workout?.exercises?.count ?? 0))
            }
            Divider()
            HStack {
                
                // Total number of sets in workout.
                WorkoutSummaryBoxRow(name: "Total Sets",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String((workoutHistory.workout?.exerciseArray.reduce(0) { $0 + $1.reps!.count })!))
                
                // Total reps completed during the workout.
                WorkoutSummaryBoxRow(name: "Total Reps",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(calcTotalReps(sets: Int(workoutHistory.workout?.sets ?? 0),
                                            exercises: workoutHistory.workout?.exerciseArray ?? [])))
            }
            Divider()
            if (workoutHistory.avgHeartRate > 0) {
                HStack {

                    // Average Heart Rate.
                    WorkoutSummaryBoxRow(name: "Avg. Heart Rate",
                                         colour: .red,
                                         value: String(Int((workoutHistory.avgHeartRate))),
                                         unit: "BPM")
                    
                    // Calories Burnt.
                    WorkoutSummaryBoxRow(name: "Total Calories",
                                         colour: .blue,
                                         value: String(Int((workoutHistory.calories))),
                                         unit: "CAL")
                }
                Divider()
            }
        }
        .padding([.top, .bottom])
    }
}
