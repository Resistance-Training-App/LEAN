//
//  WorkingOutExercise.swift
//  Workout Planner
//
//  Shows details of the current exercise the user is doing as well as previews of the previous and
//  next exercise in the workout.
//

import SwiftUI

struct WorkingOutExercise: View {

    @EnvironmentObject var workout: WorkoutManager
    
    var body: some View {
        VStack {
            Spacer()

            // Displays picture of the previous, current and next exercise in the workout.
            WorkingOutExerciseImage()
            
            Spacer()
            
            GeometryReader { reader in
                ZStack {
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold) {

                        // Exercise pre-countdown (3...2...1) and countdown timers for hold exercises
                        // and rests.
                        WorkingOutExerciseTimer()
                    } else {
                        
                        // Details of the current exercise including the weight, reps and equipment.
                        WorkingOutExerciseDetails()
                    }
                }
                .frame(width: reader.size.width, height: reader.size.height)
            }
            Spacer()
        }
    }
}
