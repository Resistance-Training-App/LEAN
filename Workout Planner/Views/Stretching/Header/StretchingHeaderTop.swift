//
//  StretchingHeaderTop.swift
//  StretchingHeaderTop
//
//  The top of the header including the percentage the user is through the stretching, time elapsed
//  and estimated minutes remaining.
//

import SwiftUI

struct StretchingHeaderTop: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    var progress: Double
    var totalStretchingTime: Double
    
    var body: some View {
        HStack {

            // Percentage of the way through the stretching.
            Text("\(Int(round(progress*100)))%")
                .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                .frame(width: UIScreen.main.bounds.size.width / 3)

            Spacer()
            
            // Current time spent on this warm-up/cooldown.
            Text(formatSeconds(seconds: Int(workout.timer.secondsElapsed)))
                .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                .frame(width: UIScreen.main.bounds.size.width / 3)
                .foregroundColor(.green)

            Spacer()

            // Estimated amount of time left in this warm-up/cooldown.
            HStack {
                Text(((Int((totalStretchingTime * (1-progress))/60)) == 0 ? "<1" :
                String(Int((totalStretchingTime * (1-progress))/60))))
                    .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                
                Text("mins\nleft")
                    .font(Font.monospacedDigit(Font.system(size: 20))())
            }
            .frame(width: UIScreen.main.bounds.size.width / 3)
        }
    }
}
