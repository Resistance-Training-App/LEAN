//
//  StretchingHeader.swift
//  StretchingHeader
//
//  Progress and other numbers displayed at the top of the screen while stretching.
//

import SwiftUI

struct StretchingHeader: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    // Returns the overall progress through the stretching as a number between 0 and 1 to be later
    // converted to a percentage.
    private var progress: Double {
        let stretchesDone = stretches.filter({ $0.order < workout.currentStretch}).map({ $0.repTime })
        let stretchesTotal = stretches.map({ $0.repTime })

        return Double(stretchesDone.reduce(0, +)) / Double(stretchesTotal.reduce(0, +))
    }
    
    // Returns the overall estimated time the stretching will take to be able to display progress in
    // terms of time remaining.
    private var totalStretchingTime: Double {
        let StretchingTime = stretches.map({ $0.repTime })
    
        return StretchingTime.map({ $0 + 3 }).reduce(0, +)
    }
    
    var body: some View {
        VStack {

            // The top of the header including the time and estimated minutes remaining.
            StretchingHeaderTop(progress: progress, totalStretchingTime: totalStretchingTime)

            // Progress bar showing the overall progress through the warm-up/cooldown.
            ProgressBar(progress: progress)
                .frame(height: 20)
            
            // Shows the user which stretch they are currently on.
            StretchingHeaderBottom(stretches: stretches)
        }
        .padding([.leading, .trailing])
    }
}
