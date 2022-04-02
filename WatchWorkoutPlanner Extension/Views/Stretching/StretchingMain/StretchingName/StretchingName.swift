//
//  StretchingName.swift
//  StretchingName
//
//  Displays the name of the current stretch.
//

import SwiftUI

struct StretchingName: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        
        // Current stretch name.
        Text(stretches[workout.currentStretch].name ?? "")
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .padding([.top, .bottom], -10)
            .frame(width: WKInterfaceDevice.current().screenBounds.width, height: 30)
    }
}
