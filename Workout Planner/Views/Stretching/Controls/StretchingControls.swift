//
//  StretchingControls.swift
//  StretchingControls
//
//  Buttons to control the warm-up/cooldown found at the bottom of the screen for easy one-handed use.
//

import SwiftUI

struct StretchingControls: View {

    @State var showingAlert = false

    let stretches: [Stretch]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {

                // Return to the previous stretch.
                StretchingPrevious(stretches: stretches)
                Spacer()
                
                // Plays/pauses the warm-up/cooldown based on the current play/pause status of the
                // warm-up/cooldown.
                StretchingPlayPause(stretches: stretches)
                Spacer()
                
                // Go to the next stretch.
                StretchingNext(stretches: stretches)
            }
            .padding(.leading)

            // Exit the entire workout early.
            WorkingOutExit(showingAlert: $showingAlert)
        }
    }
}
