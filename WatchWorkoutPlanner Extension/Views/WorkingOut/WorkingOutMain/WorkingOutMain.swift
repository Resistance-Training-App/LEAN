//
//  WorkingOutMain.swift
//  WorkingOutMain
//
//  The main view displayed when working out having the most important information and controls.
//

import SwiftUI

struct WorkingOutMain: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        VStack {

            // Progress bar
            if (!workout.justWorkout) {
                WorkingOutHeader()
            Spacer()
            }
            HStack {
                
                // Numbers such as time, heart rate and calories burnt.
                WorkingOutNumbers()
                Spacer()
                
                // Current exercise picture and name.
                WorkingOutExercise()
            }
            Spacer()
            if (!workout.justWorkout) {
                if (workout.myWorkout.exerciseArray[workout.currentExercise].isHold) {

                    // Exercise pre-countdown (3...2...1) and countdown timers for hold exercises
                    // and rests.
                    WorkingOutExerciseTimer()
                } else {
                    
                    // Details of the current exercise including the weight, reps and equipment.
                    WorkingOutExerciseDetails().environmentObject(profile)
                }
            } else {
                
                // Displays the current exercise form and rep count if running an open workout.
                WorkingOutExerciseForm()
            }
            
            Spacer()

            // Buttons to control your workout.
            if (!workout.justWorkout) {
                WorkingOutControls()
                Spacer()
            }
        }
        .frame(width: WKInterfaceDevice.current().screenBounds.width,
               height: WKInterfaceDevice.current().screenBounds.height)
    }
}
