//
//  WorkoutExerciseRow.swift
//  WorkoutExerciseRow
//
//  An exercise row displayed in workout detail and the secondary page of the working out view.
//

import SwiftUI
import CoreData

struct WorkoutExerciseRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile
    
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Exercise image.
                CircleImageExercise(exercise: exercise, size: 35, showDetails: true)
                    .padding()

                VStack(alignment: .leading) {
                    // Exercise name.
                    Text(exercise.name ?? "")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Exercise category (E.g. Upper Body).
                    Text(exercise.category ?? "" == "All" ? "All Body" : exercise.category ?? "")
                        .font(.system(size: 12, design: .default))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            HStack {
                Spacer()
                
                // If the exercise is a hold, display the time. Otherwise display the weight and
                // reps of the workout.
                if (exercise.isHold) {
                    VStack {
                        Text("Time")
                        Text("\(String(format: "%.f", exercise.repTime)) Seconds")
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack {
                        Text("Weight")
                        ForEach(exercise.weightArray, id: \.self) { weight in
                            Text("\(String(format: weight.count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", weight.count)) \(profile.weightUnit ?? "")")
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Reps")
                        ForEach(exercise.repsArray, id: \.self) { rep in
                            Text(String(format: "%.0f", rep.count))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
            }

            Divider()
                .padding([.top, .bottom], 5)
        }
    }
}
