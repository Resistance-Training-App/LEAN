//
//  WorkoutExerciseRowSetsEdit.swift
//  Workout Planner
//
//  Page to edit the sets of an exercise within a workout.
//

import SwiftUI

struct WorkoutExerciseRowSetsEdit: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var profile: Profile

    @ObservedObject var exercise: Exercise
    
    @Binding var newExerciseWeight: [Double]
    @Binding var newExerciseReps: [Double]

    @State var setIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Form {

                // Three wheel pickers to select the set, weight and number of reps for the
                // exercise that is being added to the workout.
                HStack {
                    VStack(spacing: 0) {
                        Text("Set")
                            .font(.headline)

                        CustomIntPicker(selection: $setIndex,
                                        list: Array(0...newExerciseWeight.count-1),
                                        unit: "")
                            .id(setIndex)
                    }
                    VStack(spacing: 0) {
                        Text("Weight")
                            .font(.headline)

                        CustomPicker(selection: $newExerciseWeight[setIndex],
                                     list: Array(stride(from: 0, through: 999, by: 0.5)),
                                     unit: profile.weightUnit ?? "")
                            .id(setIndex)
                    }
                    VStack(spacing: 0) {
                        Text("Reps")
                            .font(.headline)

                        CustomPicker(selection: $newExerciseReps[setIndex],
                                     list: Array(stride(from: 1, through: 999, by: 1)),
                                     unit: "")
                            .id(setIndex)
                    }
                }
            }

            // A table of the current sets.
            if ((exercise.isHold) == false) {
                WorkoutExerciseSets(newExerciseWeight: $newExerciseWeight,
                                    newExerciseReps: $newExerciseReps,
                                    setIndex: $setIndex)
            }
        }
        .navigationTitle(exercise.name ?? "")
    }
}
