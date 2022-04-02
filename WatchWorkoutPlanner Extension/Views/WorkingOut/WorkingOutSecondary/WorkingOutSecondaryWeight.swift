//
//  WorkingOutSecondaryWeight.swift
//  WatchWorkoutPlanner Extension
//
//  Allows the user to select the weight during an open workout.
//

import SwiftUI

struct WorkingOutSecondaryWeight: View {
    
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var workout: WorkoutManager
    
    private var weights = Array(stride(from: 0, through: 999, by: 0.5))

    var body: some View {
        Picker("Weight", selection: $workout.currentWeightChoice) {
            ForEach(weights, id: \.self) { weight in
                Text("\(String(weight.formatted())) \(profile.weightUnit ?? "")").tag(weight)
            }
        }
        .frame(width: WKInterfaceDevice.current().screenBounds.width,
               height: WKInterfaceDevice.current().screenBounds.height/2)
    }
}
