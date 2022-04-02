//
//  WorkoutNew.swift
//  Workout Planner
//
//  Main page for editing or creating a new workout.
//

import SwiftUI

struct WorkoutEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var allExercises: FetchedResults<Exercise>

    @Binding var workoutData: Workout.Template
    @Binding var deletedExercises: [Exercise]

    @State private var editMode = EditMode.inactive
    @State private var showAddExercise = false

    var body: some View {
        List {

            // Section allowing you to edit the name and number of sets in the workout.
            Section(header: Text("Details")) {
                WorkoutDetailsEdit(workoutData: $workoutData)
            }

            // Section listing the exercises in the workout with the ability to delete, re-order
            // and edit the weight and number of reps of each exercise.
            Section(header: ExerciseListHeader(editMode: $editMode)) {
                ForEach(workoutData.exercises.sortedArray(using:
                        [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)]) as! [Exercise],
                        id: \.self) { exercise in
                    WorkoutExerciseRowEdit(exercise: exercise, editMode: $editMode)
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
                .padding(.bottom)
            }
            .textCase(nil)

        }
        .environment(\.editMode, $editMode)
        .listStyle(GroupedListStyle())
        .navigationTitle(workoutData.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {

            // Button to add a new exercise to the workout.
            NavigationLink(destination: WorkoutAddExercise(workoutData: $workoutData,
                                                           allExercises: allExercises)) {
                HStack {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("Add Exercise")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        }
    }
    
    // Exercise list header which includes a button to toggle the edit mode on the list of exercises.
    struct ExerciseListHeader: View {
        
        @Binding var editMode: EditMode
        
        var body: some View {
            HStack {
                Text("EXERCISES")
                Spacer()
                Button {
                    if (editMode.isEditing) {
                        editMode = EditMode.inactive
                    } else {
                        editMode = EditMode.active
                    }
                } label: {
                    if (editMode.isEditing) {
                        Text("Done")
                            .font(.body)
                    } else {
                        Text("Edit")
                            .font(.body)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
    
    // Function to delete an exercise from the workout.
    private func onDelete(offsets: IndexSet) {
        var orderedExercises = workoutData.exercises.sortedArray(using:
                               [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)])
                               as! [Exercise]
        let exercise = orderedExercises[offsets.first!]

        deletedExercises.append(exercise)
        orderedExercises.remove(at: offsets.first!)
        workoutData.exercises = NSSet(array: orderedExercises)
    }
    
    // Function to change the position an exercise appears in the workout.
    private func onMove(source: IndexSet, destination: Int) {
        let newDestination: Int
        let orderedExercises = workoutData.exercises.sortedArray(using:
                               [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)])
                               as! [Exercise]
        
        if (source.first! < destination) {
            newDestination = destination - 1
        } else {
            newDestination = destination
        }

        orderedExercises[source.first!].order = Int64(newDestination)
        let movedExercise = orderedExercises[source.first!]
        
        for exercise in orderedExercises {
            if (exercise != movedExercise) {
                if (source.first! > newDestination) {
                    if (exercise.order < source.first! && exercise.order >= newDestination) {
                        exercise.order += 1
                    }
                } else {
                    if (exercise.order <= newDestination && exercise.order > source.first!) {
                        exercise.order -= 1
                    }
                }
            }
        }
        
        workoutData.exercises = NSSet(array: orderedExercises)
    }

}
