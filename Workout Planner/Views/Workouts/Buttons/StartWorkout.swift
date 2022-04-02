//
//  StartWorkout.swift
//  StartWorkout
//
//  Button to start the workout if the workout contains exercises.
//

import SwiftUI

struct StartWorkout: View {

    @EnvironmentObject var workout: WorkoutManager
    
    var myWorkout: Workout
    
    var body: some View {
        if (myWorkout.exercises?.count ?? 0 > 0) {
            Button() {
                workout.myWorkout = myWorkout
                workout.startWorkout()
            } label: {
                Label("Start Workout", systemImage: "play.circle")
            }
        }
    }
}
