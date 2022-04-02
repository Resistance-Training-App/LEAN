//
//  CircleImageExercise.swift
//  Workout Planner
//
//  Draws a circle and adds shadow around a an exercise image.
//

import SwiftUI

struct CircleImageExercise: View {

    @ObservedObject var exercise: Exercise
    var size: CGFloat
    var showDetails: Bool?

    var body: some View {
        Image(uiImage: exercise.picture != nil ?
                       UIImage(data: exercise.picture ?? Data.init())! :
                       UIImage(named: exercise.name ?? "") ?? UIImage())
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.orange, lineWidth: size/20))
            .shadow(radius: 3)

        // Display a star if the exercise had been added to the favourites.
        .if (exercise.isFavourite && showDetails == true) {
            $0.overlay(
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: size/6, height: size/6)
                    .position(x: size, y: size/16)
                    .foregroundColor(.yellow)
            )
        }
        
        // Display a brain if the exercise had been learnt by the machine learning algorithm.
        .if (exercise.isLearnt && showDetails == true) {
            $0.overlay(
                Image(systemName: "brain")
                    .resizable()
                    .frame(width: size/6, height: size/6)
                    .position(x: 0, y: size/16)
                    .foregroundColor(.pink)
            )
        }
    }
}
