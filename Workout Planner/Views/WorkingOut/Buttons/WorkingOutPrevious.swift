//
//  WorkingOutPrevious.swift
//  Workout Planner
//
//  Button to return to the previous exercise or reset the workout timer if they are already on the
//  first exercise of the workout.
//

import SwiftUI

    struct WorkingOutPrevious: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        ZStack {

            // Restart button
            if (workout.currentExercise == 0 && workout.currentSet == 0 &&
            workout.currentExerciseSet == 0) { //&& workout.myWorkout.warmUp == StretchLength.none.id) {
                Button {
                    workout.restartWorkout(countdownTime: profile.countdown)
                } label: {
                    Text("Restart")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                
            // Previous exercise button.
            } else {
                Button {
                    previousExercise(workout: workout, countdownTime: profile.countdown)
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled(workout.mode == .running && (workout.currentExercise != 0 ||
                          workout.currentSet != 0 || workout.currentExerciseSet != 0) ? false : true)
            }
        }
    }
}
