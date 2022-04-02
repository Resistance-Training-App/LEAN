//
//  StretchingHeaderBottom.swift
//  StretchingHeaderBottom
//
//  Shows the user which stretch they are currently on out of the total.
//

import SwiftUI

struct StretchingHeaderBottom: View {
    
    @EnvironmentObject var workout: WorkoutManager
    
    let stretches: [Stretch]
    
    var body: some View {
        HStack {
            Text("Stretch")
                .font(.title3)

            ForEach(stretches) { stretch in
                if (workout.currentStretch >= stretch.order) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 10, height: 10)
                        .padding(.top, 2)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 10, height: 10)
                        .padding(.top, 2)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 30)
        .padding(.bottom)
    }
}
