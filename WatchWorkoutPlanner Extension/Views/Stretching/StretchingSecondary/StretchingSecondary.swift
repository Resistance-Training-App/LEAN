//
//  StretchingSecondary.swift
//  StretchingSecondary
//
//  The secondary view displayed when stretching having less important information and controls.
//

import SwiftUI

struct StretchingSecondary: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            HStack {
                
                // Play/pause the warm-up/cooldown.
                PlayPause()
                
                // Exit the entire workout early, discarding the workout if exited in less than 10
                // seconds.
                Exit(showingAlert: $showingAlert)
            }

            // Displays the stretch progress in the warm-up/cooldown using dots.
            StretchingSecondaryDetails(stretches: stretches)
                .padding(.bottom)
            Divider()
            
            // A list of stretches in the current warm-up/cooldown.
            ForEach(stretches) { stretch in
                StretchRow(stretch: stretch)
            }
        }
    }
}
