//
//  WorkoutExerciseSetRow.swift
//  Workout Planner
//
//  Displays the weight and number of reps of each set for an exercise in an exercise row.
//

import SwiftUI

struct WorkoutExerciseSetRow: View {
    
    @EnvironmentObject var profile: Profile
    
    @ObservedObject var exercise: Exercise

    var body: some View {
        Spacer()
        
        // Display the time if the exercise is a hold.
        if (exercise.isHold) {
            VStack(spacing: 10) {
                Text("Time").fontWeight(.bold)
                Text("\(String(format: "%.f", exercise.repTime)) Seconds")
                    .foregroundColor(.secondary)
            }
        } else {

            // Exercise set weight.
            VStack(spacing: 10) {
                Text("Weight").fontWeight(.bold)
                ForEach(exercise.weightArray, id: \.self) { weight in
                    Text("\(String(format: weight.count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", weight.count)) \(profile.weightUnit ?? "")")
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            
            // Exercise set reps.
            VStack(spacing: 10) {
                Text("Reps").fontWeight(.bold)
                ForEach(exercise.repsArray, id: \.self) { rep in
                    Text(String(format: "%.0f", rep.count))
                        .foregroundColor(.secondary)
                }
            }
        }
        Spacer()
    }
}
