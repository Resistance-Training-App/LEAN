//
//  ProgressBar.swift
//  ProgressBar
//
//  Displays the progress through the workout at the top of the main workout out view.
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
                    .foregroundColor(Color(white: 0.1))
                
                // Progress bar
                Rectangle()
                    .frame(width: abs(min(CGFloat(progress) * geometry.size.width, geometry.size.width)),
                           height: geometry.size.height)
                    .foregroundColor(Color.orange)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(10)
        }
    }
}
