//
//  StretchRow.swift
//  StretchRow
//
//  An individual row showing details about a particular stretch.
//

import SwiftUI

struct StretchRow: View {
    
    let stretch: Stretch
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Stretch name.
            Text(stretch.name ?? "")
                .font(.system(size: 16, design: .default))
                .foregroundColor(.primary)
            
            // Stretch category (E.g. Upper Body).
            Text(stretch.category ?? "")
                .font(.system(size: 12, design: .default))
                .foregroundColor(.secondary)
            
            HStack {
                
                // Stretch image.
                CircleImageStretch(stretch: stretch, size: 35)
                    .padding([.top, .bottom])
                    .padding(.leading, 1)

                Spacer()

                // Time spent on this stretch.
                VStack {
                    Text("Time")
                    Text("\(String(format: "%.f", stretch.repTime)) Seconds")
                }

                Spacer()
            }
            Divider()
                .padding([.top, .bottom], 5)
        }
    }
}
