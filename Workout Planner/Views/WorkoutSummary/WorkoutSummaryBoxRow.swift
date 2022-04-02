//
//  WorkoutSummaryBoxRow.swift
//  Workout Planner
//
//  A row of text to be displayed in the workout summary box.
//

import SwiftUI
import Charts

struct WorkoutSummaryBoxRow: View {
    
    @Environment(\.colorScheme) var colourScheme

    var name: String?
    var colour: Color?
    var value: String?
    var unit: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Name of statistic.
            Text(name ?? "")
                .font(.system(size: 16))
                .foregroundColor(colourScheme == .dark ?
                                 Color(white: 0.9) :
                                 Color(white: 0.1))

            // Number and unit if provided.
            HStack(spacing: 0) {
                Text(value ?? "")
                    .font(.system(size: 26))
                    .foregroundColor(colour)
                
                Text(unit ?? "")
                    .font(.system(size: 20))
                    .foregroundColor(colour)
            }
        }
        .frame(width: 150, alignment: .leading)
        .padding(.bottom, -5)
    }
}
