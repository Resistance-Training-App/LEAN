//
//  StretchingNumbers.swift
//  StretchingNumbers
//
//  View includes the current time into the warm-up/cooldown and heart rate.
//

import SwiftUI

struct StretchingNumbers: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    var body: some View {

        TimelineView(NumbersTimelineSchedule(from: workout.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading, spacing: -5) {
                
                // Time
                if (WKInterfaceDevice.current().screenBounds.height > 197) {
                    Text(formatSeconds(seconds: Int(workout.builder?.elapsedTime ?? 0)))
                        .font(Font.monospacedDigit(Font.system(size:
                            ((workout.builder?.elapsedTime ?? 0) < 3600 ? 34 : 24)).weight(.bold))())
                        .fontWeight(.regular)
                        .foregroundColor(Color.green)
                } else {
                    Text(formatSeconds(seconds: Int(workout.builder?.elapsedTime ?? 0)))
                        .font(Font.monospacedDigit(Font.system(size:
                            ((workout.builder?.elapsedTime ?? 0) < 3600 ? 30 : 20)).weight(.bold))())
                        .fontWeight(.regular)
                        .foregroundColor(Color.green)
                }
    
                // Heart rate
                HStack {
                    Text(workout.heartRate.formatted(.number.precision(.fractionLength(0))))
                        .fontWeight(.regular)
                        .font(.system(size: WKInterfaceDevice.current().screenBounds.height > 197 ? 34 : 30))
                        .foregroundColor(Color.red)

                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red)
                }
            }
            .padding([.top, .bottom], -5)
        }
    }
}
