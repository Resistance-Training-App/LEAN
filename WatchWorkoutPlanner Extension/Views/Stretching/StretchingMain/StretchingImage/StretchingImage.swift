//
//  StretchingImage.swift
//  StretchingImage
//
//  Displays the image of the stretch in the warm-up/cooldown.
//

import SwiftUI

struct StretchingImage: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        VStack {
        
            // Displays a different image size depending on the watch screen size.
            CircleImageStretch(stretch: stretches[workout.currentStretch],
                        size: WKInterfaceDevice.current().screenBounds.height > 197 ? 65 : 55)
        }
        .padding(.trailing, 2)
        .padding([.top, .bottom], -5)
    }
}
