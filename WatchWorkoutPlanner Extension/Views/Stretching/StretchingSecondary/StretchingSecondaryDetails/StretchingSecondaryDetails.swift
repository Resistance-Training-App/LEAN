//
//  StretchingSecondaryDetails.swift
//  StretchingSecondaryDetails
//
// Displays the stretch progress in the warm-up/cooldown using dots.
//

import SwiftUI

struct StretchingSecondaryDetails: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    // Returns the overall progress through the stretching as a number between 0 and 1 to be later
    // converted to a percentage.
    private var progress: Double {
        let stretchesDone = stretches.filter({ $0.order < workout.currentStretch}).map({ $0.repTime })
        let stretchesTotal = stretches.map({ $0.repTime })

        return Double(stretchesDone.reduce(0, +)) / Double(stretchesTotal.reduce(0, +))
    }
    
    var body: some View {
        HStack {
            VStack {
            
                Text("Stretch")
                
                // Display as fraction if there are too many stretches to display on the screen.
                HStack {
                    if (stretches.count < 7) {
                        ForEach(stretches.indices, id: \.self) { i in
                            if (workout.currentStretch >= i) {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    } else {
                        Text("\(workout.currentStretch+1)/\(stretches.count)")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)

            VStack {

                // Percentage of the way through the stretching.
                HStack {
                    Text(String(Int(round(progress*100))))
                        .fontWeight(.regular)
                        .font(.system(size: 32))

                    Text("%")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }

                // User's activity rings.
                // Explanation: https://www.apple.com/uk/watch/close-your-rings/
                ActivityRings(healthStore: workout.healthStore)
                    .frame(width: 50)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
