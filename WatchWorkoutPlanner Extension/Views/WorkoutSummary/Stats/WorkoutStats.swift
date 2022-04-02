//
//  WorkoutStats.swift
//  WorkoutStats
//
//  Statistics on the completed workout.
//

import SwiftUI
import HealthKit

struct WorkoutStats: View {
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        VStack(alignment: .leading) {

            // Time taken to complete workout.
            WorkoutStatsRow(name: "TIME",
                            colour: Color.green,
                            value: String(formatSeconds(seconds: Int(workout.appleWorkout?.duration ?? 0))))
            
            // Average heart rate during the workout.
            WorkoutStatsRow(name: "AVG. HEART RATE",
                            colour: Color.red,
                            value: String(workout.averageHeartRate.formatted(.number.precision(.fractionLength(0)))),
                            unit: "BPM")
            
            // Average heart rate during the workout.
            WorkoutStatsRow(name: "TOTAL CALORIES",
                            colour: Color.blue,
                            value: String(Int(workout.activeEnergy)),
                            unit: "CAL")
            
            // Total reps completed during the workout.
            if (!workout.justWorkout) {
                WorkoutStatsRow(name: "TOTAL REPS",
                                colour: Color.white,
                                value: String(calcTotalReps(sets: Int(workout.myWorkout.sets),
                                                            exercises: workout.myWorkout.exerciseArray)))
            }

            Divider()
        }
    }
}
