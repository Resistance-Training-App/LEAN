//
//  WorkingOutSecondaryDetails.swift
//  WorkingOutSecondaryDetails
//
//  Displays the exercise and set progress in the current workout using dots.
//

import SwiftUI

struct WorkingOutSecondaryDetails: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    // Returns the overall progress through the workout as a number between 0 and 1 to be later
    // converted to a percentage.
    private var progress: Double {

        // Prevents a divide by 0 error
        guard workout.myWorkout.time > 0 else { return 1 }

        return Double(workout.timeDone) / Double(workout.myWorkout.time)
    }
    
    var body: some View {
        HStack {
            VStack {

                // Display as fraction if there are too many exercises to display on the screen.
                Text("Exercise")
                HStack {
                    if (workout.myWorkout.exercises?.count ?? 0 < 7) {
                        ForEach(0..<(workout.myWorkout.exercises?.count ?? 0), id: \.self) { i in
                            if (workout.currentExercise >= i) {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    } else {
                        Text("\(workout.currentExercise+1)/\(workout.myWorkout.exercises?.count ?? 0)")
                            .font(.title3)
                            .bold()
                            .monospacedDigit()
                    }
                }
                Spacer()
                
                // Display as fraction if there are too many sets to display on the screen.
                Text("Set")
                HStack {
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].repsArray.count == 1) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 10, height: 10)
                    } else if (workout.myWorkout.exerciseArray[workout.currentExercise].repsArray.count < 7) {
                        ForEach(0..<(workout.myWorkout.exerciseArray[workout.currentExercise].repsArray.count), id: \.self) { i in
                            if (workout.currentExerciseSet >= i) {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    } else {
                        Text("\(workout.currentExerciseSet+1)/\(workout.myWorkout.exerciseArray[workout.currentExercise].repsArray.count)")
                            .font(.title3)
                            .bold()
                            .monospacedDigit()
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)

            VStack {

                // Percentage of the way through the workout.
                HStack {
                    Text(String(Int(round(progress*100))))
                        .fontWeight(.regular)
                        .font(.title2)

                    Text("%")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }

                // User's activity rings.
                // Explanation: https://www.apple.com/uk/watch/close-your-rings/
                ActivityRings(healthStore: workout.healthStore)
                    .frame(width: 50)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
