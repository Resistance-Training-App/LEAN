//
//  StretchingMain.swift
//  StretchingMain
//
//  The main centre view displayed while stretching.
//

import SwiftUI

struct StretchingMain: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        VStack {

            // Progress bar
            StretchingHeader(stretches: stretches)
            Spacer()
            HStack {
                
                // Numbers such as time and heart rate.
                StretchingNumbers()

                Spacer()
                
                // Current stretch image.
                StretchingImage(stretches: stretches)
            }
            
            // Name of the current stretch.
            StretchingName(stretches: stretches)
            
            Spacer()

            // Exercise pre-countdown (3...2...1) and countdown timers for each stretch.
            StretchingTimer(stretches: stretches)

            Spacer()

            // Buttons to control your warm-up/cooldown.
            StretchingControls(stretches: stretches)
            Spacer()
        }
        .frame(width: WKInterfaceDevice.current().screenBounds.width,
               height: WKInterfaceDevice.current().screenBounds.height)
    }
}
