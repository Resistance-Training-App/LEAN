//
//  WorkingOutExerciseTimer.swift
//  Workout Planner
//
//  Exercise pre-countdown (3...2...1) and countdown after for hold exercises and rests.
//

import SwiftUI

struct WorkingOutExerciseTimer: View {

    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        ZStack {

            // Show countdown for the timed exercise.
            if (workout.countdown.mode != .stopped) {
                CountdownBar(progress: workout.countdown.secondsElapsed /
                             (workout.myWorkout.exerciseArray[workout.currentExercise].repTime),
                             size: 180)

                Circle()
                    .fill(colourScheme == .dark ?
                            Color(white: 0.1) :
                            Color(white: 0.9))
                    .frame(width: 150, height: 150)
                
                Text(String(Int(workout.countdown.secondsElapsed + 0.9)))
                    .font(Font.monospacedDigit(Font.system(size: 100).weight(.bold))())
                    .frame(maxWidth: .infinity, maxHeight: 180)


                    // Keep checking to see if the countdown has finished. End the workout if it was
                    // the last exercise, starting a cooldown if included in the workout otherwise
                    // move onto the next exercise.
                    .onChange(of: workout.countdown.secondsElapsed, perform: { value in

                        if (workout.countdown.secondsElapsed <= 0.1) {
                            workout.countdown.stop()

                            if (workout.currentExercise == workout.myWorkout.exercises!.count-1 &&
                            workout.currentSet == workout.myWorkout.sets-1 &&
                            workout.myWorkout.coolDown! == StretchLength.none.id) {

                                workout.endWorkout()

                            } else if (workout.currentExercise == workout.myWorkout.exercises!.count-1 &&
                            workout.currentSet == workout.myWorkout.sets-1 &&
                            workout.myWorkout.coolDown != StretchLength.none.id) {

                                workout.stretchPeriod = .coolDown
                                workout.showingWorkoutHome = false
                                workout.showingStretchingHome = true
                                
                            } else {
                                nextExercise(workout: workout, countdownTime: profile.countdown)
                            }
                        }
                    })
                
            // Show pre-countdown timer allowing the user to prepare for the timed exercise.
            } else if (workout.preCountdown.mode != .stopped) {

                // Displays the number of the countdown.
                Text(String(Int(workout.preCountdown.secondsElapsed + 0.9)))
                    .font(Font.monospacedDigit(Font.system(size: 140).weight(.bold))())
                    .frame(maxWidth: .infinity, maxHeight: 180)

                    // Keep checking to see if either countdown has stopped to either move onto the
                    // next countdown or continue to the next exercise.
                    .onChange(of: workout.preCountdown.secondsElapsed, perform: { value in
                        if (workout.preCountdown.secondsElapsed <= 0.1) {
                            workout.preCountdown.stop()
                            workout.countdown.start(secondsElapsed:
                                workout.myWorkout.exerciseArray[workout.currentExercise].repTime)
                        }
                    })
            
            // Placeholder to prevent other elements on screen from moving before a countdown has
            // started.
            } else {
                Text("")
                    .frame(width: UIScreen.main.bounds.size.width, height: 180)
            }
        }
        
        // Start the pre-countdown or countdown as soon as the isometric hold exercise appears.
        .onAppear {
            if (workout.currentSet == 0 && workout.currentExercise == 0) {
                if (profile.countdown > 0) {
                    workout.preCountdown.start(secondsElapsed: profile.countdown)
                } else {
                    workout.countdown.start(secondsElapsed:
                        workout.myWorkout.exerciseArray[workout.currentExercise].repTime)
                }
            }
        }
    }
}
