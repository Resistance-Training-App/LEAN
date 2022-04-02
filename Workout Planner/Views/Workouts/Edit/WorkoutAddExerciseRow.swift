//
//  WorkoutAddExerciseRow.swift
//  Workout Planner
//
//  A row displayed when picking an exercise to add to a workout.
//

import SwiftUI

struct WorkoutAddExerciseRow: View {

    @Environment(\.colorScheme) var colourScheme

    let exercise: Exercise

    var body: some View {
        HStack(alignment: .center) {

            // Image of the exercise
            CircleImageExercise(exercise: exercise, size: 50)

            // Exercise name
            VStack(alignment: .leading) {
                Text(exercise.name ?? "")
            }

            Spacer()

            // Displays a yellow star if the exercise has been added to your favourites.
            if exercise.isFavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            // Display a brain if the exercise had been learnt by the machine learning algorithm.
            if exercise.isLearnt {
                Image(systemName: "brain")
                    .foregroundColor(.pink)
            }
        }
    }
}
