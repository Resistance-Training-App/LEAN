//
//  WorkoutSummaryExerciseRow.swift
//  Workout Planner
//
//  A row displayed for each exercise when viewing a workout summary.
//

import SwiftUI

struct WorkoutSummaryExerciseRow: View {

    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var profile: Profile

    let exercise: Exercise
    var isJustWorkout: Bool?

    var body: some View {
        VStack(alignment: .leading) {

            // Displays the exercise name, the area of the body it works and the equipment required.
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.name ?? "")
                        .foregroundColor(.primary)
                    Text(exercise.category ?? "" == "All" ? "All Body" : exercise.category ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Sets: " + String(exercise.reps?.count ?? 1))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if (exercise.equipment ?? "" != "All") {
                    Image(colourScheme == .dark ?
                            "\(exercise.equipment ?? "")Light" :
                            "\(exercise.equipment ?? "")Dark")
                        .resizable()
                        .frame(width: 100, height: 50, alignment: .center)
                }
            }
            
            // Displays an image, the weight used and the number of reps for that exercise.
            HStack {
                CircleImageExercise(exercise: exercise, size: 80, showDetails: true)
                    .padding(.leading, 6)
                Spacer()
                if (exercise.isHold) {
                    VStack(spacing: 10) {
                        Text("Time").fontWeight(.bold)
                        Text("\(String(format: "%.f", exercise.repTime)) Seconds")
                    }
                } else {
                    VStack(spacing: 10) {
                        Text("Weight").fontWeight(.bold)
                        ForEach(exercise.weightArray, id: \.self) { weight in
                            Text("\(String(format: weight.count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", weight.count)) \(profile.weightUnit ?? "")")
                        }
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        Text("Reps").fontWeight(.bold)
                        if (exercise.isLearnt && exercise.metrics?.anyObject() != nil) {
                            ForEach(Array(zip(exercise.metricsArray, exercise.repsArray)), id: \.0) { item in
                                if (isJustWorkout ?? false) {
                                    Text(String(item.0.repCount))
                                } else {
                                    Text("\(String(item.0.repCount)) / \(String(format: "%.0f", item.1.count))")
                                        .if(item.0.repCount >= Int64(item.1.count)) {
                                            $0.foregroundColor(.green)
                                        }
                                        .if(item.0.repCount < Int64(item.1.count)) {
                                            $0.foregroundColor(.red)
                                        }
                                }
                            }
                        } else {
                            ForEach(exercise.repsArray, id: \.self) { rep in
                                Text(String(format: "%.0f", rep.count))
                            }
                        }
                    }
                    
                    // Display the most common form during each exercise set.
                    if (exercise.isLearnt && exercise.metrics?.anyObject() != nil) {
                        Spacer()
                        VStack(spacing: 10) {
                            Text("Form").fontWeight(.bold)

                            ForEach(exercise.metricsArray, id: \.self) { metric in
                                Text(mostCommonForm(formArray: metric.results ?? []))
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
                Spacer()
            }
            Divider()
                .padding(.all, 5)
        }

        // Display a chevron to indicate the user can press the exercise to view more details.
        .if (exercise.isLearnt && (exercise.metricsArray.first?.repCount ?? 0) > 0) {
            $0.overlay (
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            )
        }
    }
}
