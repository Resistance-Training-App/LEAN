//
//  StretchingStretchImage.swift
//  StretchingStretchImage
//
//  Displays picture of the previous, current and next stretch in the warm-up/cooldown.
//

import SwiftUI

struct StretchingStretchImage: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                // Previous stretch in the workout
                VStack {
                    Spacer()
                    if (workout.currentStretch > 0) {
                        CircleImageStretch(stretch: stretches[workout.currentStretch-1], size: 50)
                            .opacity(0.6)
                    }
                }
                Spacer()
                
                // Current stretch in the workout
                VStack(spacing: 20) {
                    CircleImageStretch(stretch: stretches[workout.currentStretch], size: 180)
                }
                
                // Adjust padding if it's the first stretch in the warm-up/cooldown.
                .if(workout.currentStretch == 0) {
                    $0.padding(.leading, 50)
                }
                
                // Adjust padding if it's the last stretch in the warm-up/cooldown.
                .if(workout.currentStretch == stretches.count-1) {
                    $0.padding(.trailing, 50)
                }
                Spacer()
                
                // Next stretch in the warm-up/cooldown.
                VStack {
                    Spacer()
                    if (workout.currentStretch < stretches.count-1) {
                        CircleImageStretch(stretch: stretches[workout.currentStretch+1], size: 50)
                            .opacity(0.6)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center)
            .padding(.bottom)

            // Name of the current stretch.
            Text(stretches[workout.currentStretch].name ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(width: UIScreen.main.bounds.size.width, height: 100)
        }
    }
}
