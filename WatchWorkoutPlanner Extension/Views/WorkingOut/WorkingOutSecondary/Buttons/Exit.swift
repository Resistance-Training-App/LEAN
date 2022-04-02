//
//  Exit.swift
//  Exit
//
//  Button to exit the workout early, discarding the workout if exited in less than 10 seconds.
//

import SwiftUI

struct Exit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager

    @Binding var showingAlert: Bool
    
    var body: some View {
        Button(role: .destructive) {
            motion.stopUpdates()
            showingAlert = true
        } label: {
            Text("Exit")
        }
        // Confirmation box to prevent the user from accidentally exiting the workout early.
        .confirmationDialog("Exit the workout?", isPresented: $showingAlert) {
            Button(role: .destructive) {
                
                // Save metrics of latest exercise.
                if (!workout.justWorkout) {
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
                        saveMetrics(workout: workout, motion: motion, viewContext: viewContext)
                        motion.pauseUpdates()
                    }
                }
                
                // Discard the workout if the exit button is pressed within 10 seconds.
                if ((workout.builder?.elapsedTime ?? 0) < 10) {
                    workout.cancelWorkout()
                } else {
                    workout.endWorkout()
                }
            } label: {
                Text("Yes")
            }
        }
    }
}
