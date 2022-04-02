//
//  WorkingOutExerciseExercises.swift
//  Workout Planner
//
//  Displays picture of the previous, current and next exercise in the workout.
//

import SwiftUI

struct WorkingOutExerciseImage: View {
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                // Previous exercise in the workout
                VStack {
                    Spacer()
                    if (workout.currentExercise > 0) {
                        CircleImageExercise(exercise: workout.myWorkout.exerciseArray[workout.currentExercise-1],
                                            size: 50,
                                            showDetails: true)
                            .opacity(0.6)
                    } else if (workout.currentExercise == 0 && workout.currentSet > 0) {
                        CircleImageExercise(exercise: workout.myWorkout.exerciseArray[(workout.myWorkout.exercises?.count ?? 0)-1],
                                            size: 50,
                                            showDetails: true)
                            .opacity(0.6)
                    }
                }
                Spacer()
                
                // Current exercise in the workout
                VStack(spacing: 20) {
                    CircleImageExercise(exercise: workout.myWorkout.exerciseArray[workout.currentExercise],
                                        size: 180,
                                        showDetails: true)
                }
                
                // Adjust padding if it's the first exercise in the workout.
                .if(workout.currentExercise == 0 && workout.currentSet == 0) {
                    $0.padding(.leading, 50)
                }
                
                // Adjust padding if it's the last exercise in the workout.
                .if(workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1 &&
                    workout.currentSet == workout.myWorkout.sets-1) {
                    $0.padding(.trailing, 50)
                }
                Spacer()
                
                // Next exercise in the workout
                VStack {
                    Spacer()
                    if (workout.currentExercise < (workout.myWorkout.exercises?.count ?? 0)-1) {
                        CircleImageExercise(exercise: workout.myWorkout.exerciseArray[workout.currentExercise+1],
                                            size: 50,
                                            showDetails: true)
                            .opacity(0.6)
                    } else if (workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1
                               && workout.currentSet < workout.myWorkout.sets-1) {
                        CircleImageExercise(exercise: workout.myWorkout.exerciseArray[0],
                                            size: 50,
                                            showDetails: true)
                            .opacity(0.6)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center)

            // Name of the current exercise.
            Text(workout.myWorkout.exerciseArray[workout.currentExercise].name ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.size.width, height: 100)
        }
    }
}
