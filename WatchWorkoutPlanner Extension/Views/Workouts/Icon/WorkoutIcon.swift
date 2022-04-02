//
//  WorkoutIcon.swift
//  WorkoutIcon
//
//  The image section of the workout icon, displays up to the first four exercises in the workout.
//

import SwiftUI

struct WorkoutIcon: View {
    
    var exercises: [Exercise]
    var size: CGFloat
    
    var body: some View {
        ZStack {
            
            // Icon background
            RoundedRectangle(cornerRadius: size / 4.7)
                .fill(Color(white: 0.4))
                .frame(width: size, height: size)
            
            // Fill the workout icon with one large exercise icon if the workout only has one exercise.
            if ((exercises.count) == 1) {
                CircleImageExercise(exercise: exercises[0], size: size / 1.4)
                
            // Fill the workout icon with up to the first four exercises.
            } else if ((exercises.count) > 0) {
                VStack {
                    HStack {
                        if (exercises.count > 0) {
                            CircleImageExercise(exercise: exercises[0], size: size / 2.8)
                        }
                        if (exercises.count > 1) {
                            CircleImageExercise(exercise: exercises[1], size: size / 2.8)
                        }
                    }
                    HStack {
                        if (exercises.count > 2) {
                            CircleImageExercise(exercise: exercises[2], size: size / 2.8)
                        }
                        if (exercises.count > 3) {
                            CircleImageExercise(exercise: exercises[3], size: size / 2.8)
                        }
                    }
                }
            }
        }
    }
}
