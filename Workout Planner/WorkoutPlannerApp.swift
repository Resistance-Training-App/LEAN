//
//  Workout_PlannerApp.swift
//  Workout Planner
//
//  Main view for the iPhone application.
//

import SwiftUI
import CoreData

@main
struct WorkoutPlannerApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var workout = WorkoutManager()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workout)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }

        // Save any changes made when the app is exited.
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
