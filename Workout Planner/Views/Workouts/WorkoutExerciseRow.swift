//
//  WorkoutExerciseRow.swift
//  Workout Planner
//
//  A row displayed for each exercise when viewing a workout in detail.
//

import SwiftUI
import CoreData

struct WorkoutExerciseRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var profile: Profile

    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {

            // Displays the exercise name, the area of the body it works and the number of sets
            // within this exercise.
            HStack {
                NavigationLink(destination: ExerciseDetail(exercise: exercise)) {
                    VStack(alignment: .leading) {
                        Text(exercise.name ?? "")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(exercise.category ?? "" == "All" ? "All Body" : exercise.category ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Sets: " + String(exercise.reps?.count ?? 1))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // An image of the equipment required for the exercise.
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
                NavigationLink(destination: ExerciseDetail(exercise: exercise)) {
                    CircleImageExercise(exercise: exercise, size: 80, showDetails: true)
                        .padding(.leading, 4)
                }
                WorkoutExerciseSetRow(exercise: exercise)
            }
            Divider()
                .padding(.all, 5)
        }
    }
}
