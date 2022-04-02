//
//  StretchingHome.swift
//  StretchingHome
//
//  View displayed when a warm-up/cooldown is running on the watch.
//

import SwiftUI
import WatchKit

struct StretchingHome: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    @State var stretches: [Stretch]

    @State private var selection: Tab = .main

    enum Tab {
        case second, main, music
    }

    var body: some View {
        TabView(selection: $selection) {
            
            // Less frequently used controls and information (Left page).
            StretchingSecondary(stretches: stretches)
                .tag(Tab.second)

            // More frequently used controls and information (Centre page).
            StretchingMain(stretches: stretches)
                .tag(Tab.main)
            
            // Music player (Right view).
            NowPlayingView()
                .tag(Tab.music)
        }
        .navigationBarHidden(true)

        // Start stretches.
        .onAppear {
            if (workout.preCountdown.mode == .stopped && workout.countdown.mode == .stopped) {
                if (profile.countdown > 0) {
                    workout.preCountdown.start(secondsElapsed: profile.countdown)
                } else {
                    workout.countdown.start(secondsElapsed:
                        workout.myWorkout.stretchArray[workout.currentStretch].repTime)
                }
            }
        }
        
        // Workout summary displayed when the user finished the cooldown.
        .fullScreenCover(isPresented: $workout.showingSummaryView) {
            WorkoutSummaryHome()
        }
    }
}
