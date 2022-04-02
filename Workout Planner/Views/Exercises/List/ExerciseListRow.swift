//
//  ExerciseRow.swift
//  Workout Planner
//
//  The row displayed for each exercise on the exercise list.
//

import SwiftUI

struct ExerciseListRow: View {

    @ObservedObject var exercise: Exercise

        var body: some View {
            
            // Includes an image, name and if the exercise has been added to the favourites by the
            // user.
            HStack {
                CircleImageExercise(exercise: exercise, size: 50)

                Text(exercise.name ?? "")
                    .foregroundColor(.primary)
                    .padding(.leading, 10)

                Spacer()
                
                // Display a star if the exercise had been added to the favourites.
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
