//
//  Workout_PlannerApp.swift
//  WatchWorkoutPlanner Extension
//
//  Main view for the watch application.
//

import SwiftUI

@main
struct Workout_PlannerApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var workout = WorkoutManager()
    @StateObject private var motion = MotionManager()
    
    let persistenceController = PersistenceController.shared
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(workout)
            .environmentObject(motion)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
                case .background: persistenceController.save()
                case .inactive: break
                case .active: break
                @unknown default: break
            }
        }
    }
}
