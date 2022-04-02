//
//  WorkingOutControls.swift
//  WorkingOutControls
//
//  Main controls used when working out (Navigate to the previous and next exercise).
//

import SwiftUI

struct WorkingOutControls: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
        
    var body: some View {
        HStack {
            
            // Return to the previous exercise.
            WorkingOutPrevious()

            Spacer()
            
            // Current exercise form of the user.
            if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
                switch motion.results.last ?? "Other" {
                case "Other":
                    Text("Resting")
                case "Good":
                    Text("Excellent Form")
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                default:
                    Text(addSpaces(text: motion.results.last ?? ""))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }

            // Go to the next exercise.
            WorkingOutNext()
        }
    }
}
