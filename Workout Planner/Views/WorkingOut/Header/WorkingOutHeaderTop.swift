//
//  WorkingOutHeaderTop.swift
//  Workout Planner
//
//  The top of the header including the percentage the user is through the workout, time elapsed and
//  estimated minutes remaining.
//

import SwiftUI

struct WorkingOutHeaderTop: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    var progress: Double

    var body: some View {
        HStack {
            
            // Percentage of the way through the workout.
            Text("\(Int(round(progress*100)))%")
                .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                .frame(width: UIScreen.main.bounds.size.width / 3)

            Spacer()
            
            // Current time spent on this workout
            Text(formatSeconds(seconds: Int(workout.timer.secondsElapsed)))
                .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                .frame(width: UIScreen.main.bounds.size.width / 3)
                .foregroundColor(.green)

            Spacer()

            // Estimated amount of time left in this workout.
            HStack {
                Text(((workout.secondsLeft/60) == 0 ? "<1" : String(workout.secondsLeft/60)))
                    .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                
                Text("mins\nleft")
                    .font(Font.monospacedDigit(Font.system(size: 20))())
            }
            .frame(width: UIScreen.main.bounds.size.width / 3)
        }
    }
}

