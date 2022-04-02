//
//  CalcTwelveWeekData.swift
//  Workout Planner
//
//  Function to calculate the data for the 12 week graph based on the user's workout history.
//

import Foundation
import CoreData

func CalcTwelveWeekData(workoutHistories: [WorkoutHistory]) -> [Double] {

    var data: [Double] = []
    
    for i in 0..<12 {
        let weekStart = Calendar.current.date(byAdding: .weekOfYear, value: -i-1, to: Date())!
        let weekEnd = Calendar.current.date(byAdding: .weekOfYear, value: -i, to: Date())!
        
        data.append(0)
        
        for j in 0..<workoutHistories.count {
            if (workoutHistories[j].timestamp! > weekStart &&
            workoutHistories[j].timestamp! < weekEnd) {
                data[i] += ceil(workoutHistories[j].time / 60)
            }
        }
        
        // Temporary additions to data to showcase the line chart without have to have workouts over
        // the last 12 weeks.
        data[i] += Double.random(in: 200..<250)
    }

    return data.reversed()
}
