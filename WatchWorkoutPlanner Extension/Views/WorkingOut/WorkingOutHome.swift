//
//  WorkingOutHome.swift
//  WorkingOutHome
//
//  View displayed when a workout is running on the watch.
//

import SwiftUI
import CoreData
import WatchKit

struct WorkingOutHome: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile

    @State private var selection: Tab = .main

    enum Tab {
        case temporary, second, main, music
    }

    var body: some View {
        TabView(selection: $selection) {
            
            // Less frequently used controls and information (left page).
            if (!workout.justWorkout) {
                ScrollView {
                    WorkingOutSecondary()
                }
                .tag(Tab.second)
            } else {
                WorkingOutSecondary()
                    .tag(Tab.second)
            }

            // More frequently used controls and information (centre default page).
            WorkingOutMain().environmentObject(profile)
                .tag(Tab.main)
            
            // Music player (right page).
            NowPlayingView()
                .tag(Tab.music)
        }
        .navigationBarHidden(true)
        
        // Workout summary displayed when the user finished the workout.
        .fullScreenCover(isPresented: $workout.showingSummaryView) {
            WorkoutSummaryHome()
        }
    }
}
