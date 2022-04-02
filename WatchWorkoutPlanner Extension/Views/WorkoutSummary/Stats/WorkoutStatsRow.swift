//
//  WorkoutSummaryBoxRow.swift
//  WorkoutSummaryBoxRow
//
//  A row for each statistic displayed in the workout summary.
//

import SwiftUI

struct WorkoutStatsRow: View {

    var name: String
    var colour: Color
    var value: String
    var unit: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            
            // Name of statistic (Avg Heart Rate).
            Text(name)
                .font(.caption)

            HStack {
                
                // Value of statistic (135).
                Text(value)
                    .fontWeight(.regular)
                    .font(.system(size: 24))
                    .foregroundColor(colour)
                
                // Unit of statistic if provided (BPM).
                Text(unit ?? "")
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .foregroundColor(colour)
            }
        }
    }
}
