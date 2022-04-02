//
//  ContentView.swift
//  WatchWorkoutPlanner Extension
//
//  Main view only displays a workout list. Limited compared to the phone application as creating
//  workouts on the watch for example would not be a good experience on such a small screen.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    
    private var profile: Profile {
        return loadProfile(viewContext: viewContext)
    }

    var body: some View {
        WorkoutHome()
            .environmentObject(profile)
        
            // Used for debugging in a watch simulator.
            .task {
                #if targetEnvironment(simulator)
                    loadDefaultExercises(viewContext: viewContext)
                    loadDefaultStretches(viewContext: viewContext)
                    loadDefaultWorkouts(viewContext: viewContext)
                #endif
            }
    }
}
