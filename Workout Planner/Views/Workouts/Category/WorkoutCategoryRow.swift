//
//  WorkoutCategoryRow.swift
//  Workout Planner
//
//  A row to display a horizontal scroll list of workouts.
//

import SwiftUI

struct WorkoutCategoryRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var workouts: [Workout]
    var categoryName: String

    @State private var workoutID: UUID = UUID()
    @State private var showingConfirmation = false

    var body: some View {
        VStack(alignment: .leading) {

            // Category Name.
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(workouts) { myWorkout in
                        NavigationLink(destination: WorkoutDetail(myWorkout: myWorkout)) {
                            
                            // Workout picture.
                            WorkoutIcon(workout: myWorkout)

                            // Hold on a workout icon to access this menu.
                            .contextMenu {
                                
                                // Button to start the workout if the workout contains exercises.
                                StartWorkout(myWorkout: myWorkout)

                                // Button to toggle the favourite status of that workout.
                                ToggleWorkoutFavourite(isFavourite: myWorkout.isFavourite,
                                                       myWorkout: myWorkout,
                                                       workouts: workouts)

                                // Button to delete a workout.
                                DeleteWorkout(workoutID: $workoutID,
                                              showingConfirmation: $showingConfirmation,
                                              myWorkout: myWorkout,
                                              workouts: workouts)
                            }

                            // Confirmation box before deleting a workout.
                            .if (workoutID == myWorkout.id ?? UUID()) {
                                $0.confirmationDialog("Are you sure?",
                                                    isPresented: $showingConfirmation,
                                                    titleVisibility: .visible) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            removeWorkout(workout: myWorkout)
                                        }
                                    } label: {
                                        Text("Delete \(myWorkout.name ?? "Workout")")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 140)
            .padding(.bottom, 15)
        }
    }

    // Function to delete a workout.
    func removeWorkout(workout: Workout) {
        viewContext.delete(workout)
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
