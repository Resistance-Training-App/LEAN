//
//  StretchingHeader.swift
//  StretchingHeader
//
//  Top view of the stretching screen including a progress bar.

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

    var body: some View {
        VStack(alignment: .leading) {

            /*
            Text(workout.stretchPeriod == .warmUp ? "Warm-up" : "Cool-down")
                .frame(width: WKInterfaceDevice.current().screenBounds.width - 50)
                .padding(.top, 10)
                .padding(.leading, -10)
                .truncationMode(.tail)
             */

            // Progress bar showing the overall progress through this workout.
            ProgressBar(progress: progress)
                .frame(height: 3)
            
        }
        .padding(.top, 25)
    }
}
