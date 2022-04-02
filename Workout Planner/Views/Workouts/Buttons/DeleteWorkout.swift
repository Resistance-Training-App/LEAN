//
//  DeleteWorkout.swift
//  DeleteWorkout
//
//  Button to delete a workout.
//

import SwiftUI

struct DeleteWorkout: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    @Binding var workoutID: UUID
    @Binding var showingConfirmation: Bool
    
    var myWorkout: Workout
    var workouts: [Workout]
    
    var body: some View {
        Button(role: .destructive) {
            workoutID = myWorkout.id!
            showingConfirmation.toggle()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
