//
//  WorkoutSummaryBox.swift
//  WorkoutSummaryBox
//
//  Displays a summary of the stats produced from the workout.
//

import SwiftUI

struct WorkoutSummaryBox: View {

    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
                // Time taken to complete workout.
                WorkoutSummaryBoxRow(name: "Time",
                                     colour: .green,
                                     value: String(formatSeconds(seconds: Int(workout.timer.secondsElapsed))))

                // Number of exercises in each set.
                WorkoutSummaryBoxRow(name: "Total Exercises",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(workout.myWorkout.exercises?.count ?? 0))
            }
            Divider()
            HStack {
                
                // Total number of sets in workout.
                WorkoutSummaryBoxRow(name: "Total Sets",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(workout.myWorkout.exerciseArray.reduce(0) { $0 + $1.reps!.count }))
                
                // Total reps completed during the workout (assumed).
                WorkoutSummaryBoxRow(name: "Total Reps",
                                     colour: colourScheme == .dark ?
                                             Color(white: 0.9) :
                                             Color(white: 0.1),
                                     value: String(calcTotalReps(sets: Int(workout.myWorkout.sets),
                                            exercises: workout.myWorkout.exerciseArray)))
            }
            Divider()
        }
        .padding([.top, .bottom])
    }
}
