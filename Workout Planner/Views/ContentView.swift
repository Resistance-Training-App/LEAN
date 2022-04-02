//
//  ContentView.swift
//  Workout Planner
//
//  Tab view for workouts, exercises and the profile view.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    private var profile: Profile {
        return loadProfile(viewContext: viewContext)
    }

    @State private var selection: Tab = .workouts

    enum Tab {
        case workouts
        case exercises
        case profile
    }

    var body: some View {
        TabView(selection: $selection) {

            // Workout tab displaying all custom and example workouts.
            WorkoutHome()
                .tabItem {
                    if (selection == .workouts) {
                        Label("Workouts", image: "WorkoutsSelected")
                    } else {
                        Label("Workouts", image: "Workouts")
                    }
                }
                .tag(Tab.workouts)

            // Exercise tab that lists all exercises available included in the app.
            ExerciseHome()
                .tabItem {
                    if (selection == .exercises) {
                        Label("Exercises", image: "ExercisesSelected")
                    } else {
                        Label("Exercises", image: "Exercises")
                    }
                }
                .tag(Tab.exercises)

            // Profile page including workout history, statistics and settings.
            ProfileHome()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(Tab.profile)

        }
        .environmentObject(profile)
        .task {
            
            // Load the default exercises and stretches.
            loadDefaults(viewContext: viewContext)
        }
        .environment(\.colorScheme, profile.theme == Themes.system.id || profile.theme ?? "None" == "None" ? colorScheme :
                                    profile.theme == Themes.light.id ? .light : .dark)
    }
}
