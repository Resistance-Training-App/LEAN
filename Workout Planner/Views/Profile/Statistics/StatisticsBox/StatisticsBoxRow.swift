//
//  StatisticsBoxRow.swift
//  Workout Planner
//
//  A statistic row displayed in the statistics box.
//

import SwiftUI

struct StatisticsBoxRow: View {

    var name: String
    var number: String
    
    var body: some View {
        HStack {
            
            // Name of statistic
            Text(name)
                .font(.system(size: 20))
            
            Spacer()
            
            // Number for statistic.
            Text(number)
                .font(Font.monospacedDigit(Font.system(size: 20))()).bold()
        }
        .padding([.leading, .trailing])
    }
}
