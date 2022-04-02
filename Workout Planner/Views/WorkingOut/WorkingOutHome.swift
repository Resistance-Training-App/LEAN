//
//  WorkingOutHome.swift
//  Workout Planner
//
//  View displayed while working out detailing their progress, current exercise and control buttons.
//

import SwiftUI

struct WorkingOutHome: View {
    
    var body: some View {
        VStack {

            // Progress bar, time done and estimated time remaining.
            WorkingOutHeader()

            Spacer()
            
            // Current exercise details and previews of previous and next exercises either side.
            WorkingOutExercise()

            Spacer()
            
            // Buttons to control the workout.
            WorkingOutControls()
        }
    }

}
