//
//  WorkoutSummaryExerciseRow.swift
//  WatchWorkoutPlanner Extension
//
//  An exercise row displayed in the workout summary.
//

import SwiftUI
import CoreData

struct WorkoutSummaryExerciseRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var workout: WorkoutManager

    let exercise: Exercise
    let index: Int
    
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

            if (!workout.justWorkout) {
                HStack {
                    if (!exercise.isLearnt || motion.metrics[exist: index]?.count ?? 0 == 0) {
                        Spacer()
                    }
                    
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
                            if (exercise.isLearnt && motion.metrics[exist: index]?.count ?? 0 > 0) {
                                ForEach(Array(zip(motion.metrics[index], exercise.repsArray)), id: \.0) { item in
                                    Text("\(String(item.0.repCount)) / \(String(format: "%.0f", item.1.count))")
                                        .if(item.0.repCount >= Int64(item.1.count)) {
                                            $0.foregroundColor(.green)
                                        }
                                        .if(item.0.repCount < Int64(item.1.count)) {
                                            $0.foregroundColor(.red)
                                        }
                                }
                            } else {
                                ForEach(exercise.repsArray, id: \.self) { rep in
                                    Text(String(format: "%.0f", rep.count))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    Spacer()
                    
                    // Display the most common form during each exercise set.
                    if (exercise.isLearnt && motion.metrics[exist: index]?.count ?? 0 > 0) {
                        VStack {
                            Text("Form")
                            ForEach(motion.metrics[index], id: \.self) { metric in
                                Text(addSpaces(text: mostCommonForm(formArray: metric.results ?? [])))
                                    .if(mostCommonForm(formArray: metric.results ?? []) == "Good") {
                                        $0.foregroundColor(.green)
                                    }
                                    .if(mostCommonForm(formArray: metric.results ?? []) != "Good") {
                                        $0.foregroundColor(.red)
                                    }
                            }

                        }
                    }
                }
            } else {
                
                // Display the weight selected, reps counted and most common form during an open workout.
                HStack {
                    Spacer()
                    VStack {
                        Text("Weight")
                        ForEach(motion.metrics[exist: index] ?? [], id: \.self) { metric in
                            Text("\(String(metric.weightChoice.formatted())) \(profile.weightUnit ?? "")")
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Reps")
                        ForEach(motion.metrics[exist: index] ?? [], id: \.self) { metric in
                            Text(String(metric.repCount))
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Form")
                        ForEach(motion.metrics[exist: index] ?? [], id: \.self) { metric in
                            Text(addSpaces(text: mostCommonForm(formArray: metric.results ?? [])))
                                .if(mostCommonForm(formArray: metric.results ?? []) == "Good") {
                                    $0.foregroundColor(.green)
                                }
                                .if(mostCommonForm(formArray: metric.results ?? []) != "Good") {
                                    $0.foregroundColor(.red)
                                }
                        }
                    }
                    Spacer()
                }
            }
            Divider()
                .padding([.top, .bottom], 5)
        }
    }
}
