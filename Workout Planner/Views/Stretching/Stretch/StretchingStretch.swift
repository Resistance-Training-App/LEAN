//
//  StretchingStretch.swift
//  StretchingStretch
//
//  Shows details of the current stretch the user is doing as well as previews of the previous and
//  next stretches in the warm-up/cooldown.
//

import SwiftUI

struct StretchingStretch: View {

    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        VStack {
            Spacer()

            // Displays picture of the previous, current and next stretch in the workout.
            StretchingStretchImage(stretches: stretches)
            
            Spacer()
            
            // Exercise pre-countdown (3...2...1) and countdown timers for each stretch.
            StretchingStretchTimer(stretches: stretches)
            
            Spacer()

        }
    }
}
