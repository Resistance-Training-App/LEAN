//
//  WorkingOutNext.swift
//  Workout Planner
//
//  Button to go to the next exercise or finish the workout if they are on the last exercise of the
//  workout.
//

import SwiftUI

struct WorkingOutNext: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        ZStack {

            // Finish button.
            if (workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1 &&
            workout.currentExerciseSet+1 == workout.myWorkout.exerciseArray[workout.currentExercise].weight?.count &&
            workout.currentSet == workout.myWorkout.sets-1 &&
            workout.myWorkout.coolDown == StretchLength.none.id) {
                Button {

                    // Discard workout if the time working out is less than 10 seconds.
                    if (workout.timer.secondsElapsed < 10) {
                        workout.cancelWorkout()
                    } else {
                        workout.endWorkout()
                    }
                } label: {
                    Text("Finish")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)

            // Start cooldown button.
            } else if (workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1 &&
            workout.currentExerciseSet+1 == workout.myWorkout.exerciseArray[workout.currentExercise].weight?.count &&
            workout.currentSet == workout.myWorkout.sets-1 &&
            workout.myWorkout.coolDown != StretchLength.none.id) {

                Button {
                    workout.startCooldown()
                } label: {
                    Text("Start\nCooldown")
                        .fontWeight(.semibold)
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .frame(width: 80, height: 50)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, -10)
                
            // Next exercise button.
            } else {
                Button {
                    nextExercise(workout: workout, countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled(workout.mode == .running ? false : true)
            }
        }
        .padding(.trailing)
    }
}
