//
//  CategoryRow.swift
//  Workout Planner
//
//  A row to display a horizontal scroll list of exercises.
//

import SwiftUI

struct ExerciseCategoryRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var exercises: [Exercise]
    var categoryName: String
    
    @State private var exerciseID: UUID = UUID()
    @State private var showingConfirmation = false

    var body: some View {
        VStack(alignment: .leading) {

            // Category Name.
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(exercises) { exercise in
                        NavigationLink(destination: ExerciseDetail(exercise: exercise)) {
                            
                            // Exercise Picture.
                            ExerciseCategoryIcon(exercise: exercise)
                            
                            // Hold on an exercise icon to access this menu.
                            .contextMenu {
                                
                                // Button to toggle the favourite status of that exercise.
                                ToggleExerciseFavourite(isFavourite: exercise.isFavourite,
                                                        exercise: exercise,
                                                        exercises: exercises)
                                
                                // Button to delete a user created exercise
                                if (exercise.userCreated) {
                                    DeleteExercise(exerciseID: $exerciseID,
                                                   showingConfirmation: $showingConfirmation,
                                                   exercise: exercise,
                                                   exercises: exercises)
                                }
                            }

                            // Confirmation box before deleting an exercise.
                            .if (exerciseID == exercise.id ?? UUID()) {
                                $0.confirmationDialog("Are you sure?",
                                                    isPresented: $showingConfirmation,
                                                    titleVisibility: .visible) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            removeExercise(exercise: exercise)
                                        }
                                    } label: {
                                        Text("Delete \(exercise.name ?? "Exercise")")
                                    }
                                }
                            }
                        }
                        
                    }
                }
                .padding(.leading, 5)
                .padding(.trailing, 20)
            }
            .frame(height: 130)
            .padding(.bottom, 15)
        }
    }
    
    // Function to delete a user created exercise.
    func removeExercise(exercise: Exercise) {

        viewContext.delete(exercise)

        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
