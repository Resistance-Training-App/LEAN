//
//  CategoryItem.swift
//  Workout Planner
//
//  The icon used to display an exercise in the exercise category list.
//

import SwiftUI

struct ExerciseCategoryIcon: View {

    @ObservedObject var exercise: Exercise

    var body: some View {
        VStack {
            
            // Exercise image.
            CircleImageExercise(exercise: exercise, size: 100, showDetails: true)
                .padding(.top, 10)
            
            // Exercise Name.
            Text(exercise.name ?? "")
                .padding(.top, 2)
                .foregroundColor(.primary)
                .font(.caption)
                .fixedSize(horizontal: true, vertical: false)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.leading, 15)
    }
}
