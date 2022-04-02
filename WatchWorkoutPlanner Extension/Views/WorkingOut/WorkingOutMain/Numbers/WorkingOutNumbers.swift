//
//  NumbersHome.swift
//  NumbersHome
//
//  View includes the current time into the workout, heart rate and calories burnt.
//

import SwiftUI
import HealthKit

struct WorkingOutNumbers: View {
    
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        TimelineView(NumbersTimelineSchedule(from: workout.builder?.startDate ?? Date())) { context in
            VStack(alignment: .leading, spacing: -5) {
                
                // Time elapsed
                if (WKInterfaceDevice.current().screenBounds.height > 197) {
                    Text(formatSeconds(seconds: Int(workout.builder?.elapsedTime ?? 0)))
                        .font(Font.monospacedDigit(Font.system(size:
                            ((workout.builder?.elapsedTime ?? 0) < 3600 ? 34 : 22)).weight(.bold))())
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
                
                // Calories
                HStack {
                    Text(String(Int(workout.activeEnergy)))
                        .fontWeight(.regular)
                        .font(.system(size: WKInterfaceDevice.current().screenBounds.height > 197 ? 34 : 30))
                        .foregroundColor(Color.blue)

                    Text("CAL")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .foregroundColor(Color.blue)
                }
            }
            .frame(maxWidth: WKInterfaceDevice.current().screenBounds.width/2,
                   maxHeight: 90,
                   alignment: .leading)
            .if(workout.justWorkout) {
                $0.padding(.top, 40)
            }
        }
    }
}
