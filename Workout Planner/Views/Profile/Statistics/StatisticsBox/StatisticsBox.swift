//
//  StatisticsBox.swift
//  Workout Planner
//
//  A box of statistics over a given time period.
//

import SwiftUI

struct StatisticsBox: View {
    
    @Environment(\.colorScheme) var colourScheme

    var workoutHistories: [WorkoutHistory]

    var period: String

    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(colourScheme == .dark ?
                        Color(white: 0.1) :
                        Color(white: 0.9))
                .frame(maxWidth: .infinity, minHeight: 600)
        
            VStack(spacing: 15) {
                Text("Past \(period)'s activity")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .padding(.top, 10)
                
                // Number of workouts completed.
                StatisticsBoxRow(name: "Workouts",
                                 number: String(calcWorkouts(workoutHistories: Array(workoutHistories),
                                                             since: period)))

                // Time spent completing workouts.
                StatisticsBoxRow(name: "Time",
                                 number: formatSeconds(seconds:
                                                        calcTime(workoutHistories: Array(workoutHistories),
                                                                 since: period)))

                // Number of reps completed.
                StatisticsBoxRow(name: "Reps",
                                 number: String(calcReps(workoutHistories: Array(workoutHistories),
                                                         since: period)))
                
                // Pie charts for the distribution of exercises and exercise categories completed.
                if (calcWorkouts(workoutHistories: Array(workoutHistories), since: period) > 0) {
                    HStack {
                        VStack {
                            PieChart(data: calcExerciseDist(workoutHistories: Array(workoutHistories),
                                                            since: period),
                                     separatorColor: colourScheme == .dark ?
                                                     Color(white: 0.1) :
                                                     Color(white: 0.9),
                                     accentColors: pieColors)
                                .frame(width: (UIScreen.main.bounds.width-30)/2, height: 400)
                            Spacer()
                        }
                        VStack {
                            PieChart(data: calcCategoryDist(workoutHistories: Array(workoutHistories),
                                                            since: period),
                                     separatorColor: colourScheme == .dark ?
                                                     Color(white: 0.1) :
                                                     Color(white: 0.9),
                                     accentColors: pieColors)
                                .frame(width: (UIScreen.main.bounds.width-30)/2, height: 400)
                            Spacer()
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .frame(width: (UIScreen.main.bounds.width-30))
        }
        .padding()
    }
}
