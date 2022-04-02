//
//  CountdownBar.swift
//  Workout Planner
//
//  A circular countdown timer to make it easier for the user to visualise how much progress
//  they have left in a hold exercise or a rest.
//

import SwiftUI

struct CountdownBar: View {

    var progress: Double
    var size: CGFloat

    var body: some View {
        ZStack {
            
            // Inner circle
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.5)
                .foregroundColor(Color.gray)
            
            // Outer circle
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1)))
                .stroke(style: StrokeStyle(lineWidth: size/12, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
        }
        .frame(width: size, height: size, alignment: .center)
    }
}
