//
//  WorkingOutExerciseTimer.swift
//  WorkingOutExerciseTimer
//
//  Timer displayed when the exercise is timed.
//

import SwiftUI
import CoreData

struct WorkingOutExerciseTimer: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        TimelineView(NumbersTimelineSchedule(from: workout.builder?.startDate ?? Date())) { context in
            ZStack {
                
                // Background
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.1))
                    .frame(maxWidth: .infinity, maxHeight: 30)
                
                // Show countdown circle progress bar only if it's currently displaying the countdown.
                if (workout.preCountdown.mode == .stopped) {
                    ProgressBar(progress: workout.countdown.secondsElapsed /
                                workout.myWorkout.exerciseArray[workout.currentExercise].repTime)
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }

                // Displays the number of the countdown.
                Text(String(Int(workout.preCountdown.mode != .stopped ?
                                workout.preCountdown.secondsElapsed + 0.9 :
                                workout.countdown.secondsElapsed + 0.9)))
                    .font(Font.bold(Font.system(size: 30))())
                    .frame(width: 50, height: 25, alignment: .center)
                    .padding(.bottom, 1)
                
                    // Keep checking to see if either countdown has stopped to either move onto the
                    // next countdown or continue to the next exercise.
                    .onChange(of: workout.preCountdown.mode == .running ?
                                  workout.preCountdown.secondsElapsed :
                                  workout.countdown.secondsElapsed,
                              perform: { value in
                        if (workout.preCountdown.mode != .stopped) {
                            if (workout.preCountdown.secondsElapsed <= 0.1) {
                                workout.preCountdown.stop()
                                workout.countdown.start(secondsElapsed:
                                    workout.myWorkout.exerciseArray[workout.currentExercise].repTime)
                            }
                        } else {
                            if (workout.countdown.mode != .stopped) {
                                if (workout.countdown.secondsElapsed <= 0.1) {
                                    workout.countdown.stop()
                                    
                                    // Play haptic feedback to let the user know the timed exercise
                                    // has finished (the user may be in a position such that they
                                    // cannot see the Apple Watch display).
                                    WKInterfaceDevice.current().play(.success)
                                    
                                    // Save metrics of latest exercise.
                                    saveMetrics(workout: workout, motion: motion, viewContext: viewContext)
                                    
                                    if (workout.currentExercise == workout.myWorkout.exercises!.count-1 &&
                                        workout.currentSet == workout.myWorkout.sets-1 && workout.myWorkout.coolDown == StretchLength.none.id ) {
                                        workout.endWorkout()
                                    } else if (workout.currentExercise == workout.myWorkout.exercises!.count-1 &&
                                               workout.currentSet == workout.myWorkout.sets-1) {
                                        workout.startCooldown()
                                    } else {
                                        nextExercise(workout: workout,
                                                     motion: motion,
                                                     countdownTime: profile.countdown,
                                                     viewContext: viewContext)
                                    }
                                }
                            }
                        }
                    })
            }
        }
        
        // Start either the pre-countdown or countdown as soon as the isometric hold exercise appears.
        .onAppear {
            if (workout.currentSet == 0 && workout.currentExercise == 0 &&
                workout.preCountdown.mode == .stopped && workout.countdown.mode == .stopped) {
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
