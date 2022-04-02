//
//  StretchingHome.swift
//  StretchingHome
//
//  View displayed while stretching detailing their progress, current stretch and control buttons.
//

import SwiftUI

struct StretchingHome: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    @State var stretches: [Stretch]
    
    var body: some View {
        VStack {
            
            // Progress bar, time done and estimated time remaining.
            StretchingHeader(stretches: stretches)
            
            Spacer()
            
            // Current stretch details and previews of previous and next exercises either side.
            StretchingStretch(stretches: stretches)
            
            Spacer()
            
            // Buttons to control the workout.
            StretchingControls(stretches: stretches)
        }
    }
}
