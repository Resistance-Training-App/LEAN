//
//  ProgressBar.swift
//  Workout Planner
//
//  Progress bar with percentage used to display progress through a workout while working out
//

import SwiftUI

struct ProgressBar: View {

    var progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                // Background
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color.gray)
                
                // Progress bar
                Rectangle()
                    .frame(width: abs(min(CGFloat(progress) * geometry.size.width, geometry.size.width)),
                           height: geometry.size.height)
                    .foregroundColor(Color.orange)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(45)
        }
    }
}
