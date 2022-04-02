//
//  WorkingOutHeaderBottom.swift
//  Workout Planner
//
//  Shows the user which set and exercise they are currently on out of their respective totals.
//

import SwiftUI

struct WorkingOutHeaderBottom: View {

    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        HStack {
            Spacer()

            // Progress indicator of the exercises in the workout set they have completed.
            // Only displays if there is more than one exercise.
            Text("Exercise")
                .font(.title3)

            // Display as fraction if there are too many exercises to display on the screen.
            if (workout.myWorkout.exercises?.count ?? 0 < 7) {
                ForEach(0..<(workout.myWorkout.exercises?.count ?? 0), id: \.self) { i in
                    if (workout.currentExercise >= i) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 10, height: 10)
                            .padding(.top, 2)
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 10, height: 10)
                            .padding(.top, 2)
                    }
                }
            } else {
                Text("\(workout.currentExercise+1)/\(workout.myWorkout.exercises?.count ?? 0)")
                    .font(.title)
                    .bold()
                    .monospacedDigit()
            }

            Spacer()

            // Progress indicator for the amount of sets completed for this exercise.
            // Only displays if there is more than one exercise set.
            Text("Set")
                .font(.title3)

            // Display as fraction if there are too many sets to display on the screen.
            if (workout.myWorkout.exerciseArray[workout.currentExercise].weightArray.count < 7) {
                ForEach((0..<workout.myWorkout.exerciseArray[workout.currentExercise].weightArray.count), id: \.self) { i in
                    if (workout.currentExerciseSet >= i) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 10, height: 10)
                            .padding(.top, 2)
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 10, height: 10)
                            .padding(.top, 2)
                    }
                }
            } else {
                Text("\(workout.currentExerciseSet+1)/\(workout.myWorkout.exerciseArray[workout.currentExercise].weightArray.count)")
                    .font(.title)
                    .bold()
                    .monospacedDigit()
            }

            Spacer()
        }
        .padding(.bottom)
    }
}
