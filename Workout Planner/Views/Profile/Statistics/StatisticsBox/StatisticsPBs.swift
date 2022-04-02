//
//  StatisticsPBs.swift
//  StatisticsPBs
//
//  Personal best weights for each exercise completed in a workout.
//

import SwiftUI
import CoreData

struct StatisticsPBs: View {

    @Environment(\.colorScheme) var colourScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile
    
    var workoutHistories: [WorkoutHistory]

    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(colourScheme == .dark ?
                        Color(white: 0.1) :
                        Color(white: 0.9))
                .frame(maxWidth: .infinity,
                       minHeight: CGFloat(profile.personalBestArray.filter({ $0.weight > 0 }).count+1)*50)
        
            VStack(spacing: 15) {
                Text("Personal Best")
                    .font(.system(size: 22, weight: .semibold, design: .default))

                // Only display personal bests for exercises with weights.
                ForEach(profile.personalBestArray.filter({ $0.weight > 0 })) { Pb in
                    StatisticsBoxRow(name: Pb.exerciseName ?? "",
                                     number: "\(String(format: Pb.weight.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", Pb.weight)) \(profile.weightUnit ?? "")")
                }
            }
            .frame(maxWidth: .infinity, minHeight: CGFloat(profile.personalBestArray.filter({ $0.weight > 0 }).count)*50)
        }
        .padding()
    }
}
