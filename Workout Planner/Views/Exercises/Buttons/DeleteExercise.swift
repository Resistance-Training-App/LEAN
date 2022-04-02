//
//  DeleteExercise.swift
//  DeleteExercise
//
//  Button to delete a user created exercise
//

import SwiftUI

struct DeleteExercise: View {
    
    @Binding var exerciseID: UUID
    @Binding var showingConfirmation: Bool
    
    var exercise: Exercise
    var exercises: [Exercise]
    
    var body: some View {
        Button(role: .destructive) {
            exerciseID = exercise.id!
            showingConfirmation.toggle()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
