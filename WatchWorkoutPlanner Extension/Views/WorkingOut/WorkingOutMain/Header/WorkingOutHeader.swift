//
//  WorkingOutHeader.swift
//  WorkingOutHeader
//
//  Top view of the working out screen including a progress bar.
//

import SwiftUI
import CoreData

struct WorkingOutHeader: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    // Returns the overall progress through the workout as a number between 0 and 1 to be later
    // converted to a percentage.
    private var progress: Double {

        // Prevents a divide by 0 error
        guard workout.myWorkout.time > 0 else { return 1 }

        return Double(workout.timeDone) / Double(workout.myWorkout.time)
    }

    var body: some View {
        VStack(alignment: .leading) {

            // Progress bar showing the overall progress through this workout.
            ProgressBar(progress: progress)
                .frame(height: 3)
        }
        .padding(.top, modelPadding())
        .padding([.leading, .trailing], 5)
    }
    
    // Configures the top padding of the screen based on the Apple Watch model.
    func modelPadding() -> CGFloat {
        switch(WKInterfaceDevice.currentWatchModel) {
             case .w40: return 23
             case .w41: return 32
             case .w44: return 25
             case .w45: return 33
             default: return 12
        }
    }
}
