//
//  MostCommonCategory.swift
//  Workout Planner
//
//  Returns an estimate on what type of workout is based on its exercises.
//

import Foundation

func mostCommonCategory(exercises: [Exercise]) -> (String) {

    var categories: [String:Int] = ["All": 0,
                                    "Upper Body": 0,
                                    "Core": 0,
                                    "Lower Body": 0]
    
    
    for exercise in exercises {
        categories[exercise.category ?? ""]! += 1
    }

    for (_, keyValue) in categories.enumerated() {
        
        // If there's an exercise category that takes up over half of the workout, return that
        // category.
        if (exercises.count > 0) {
            if ((keyValue.1/exercises.count) * 100 > 50) {
                if (keyValue.0 == "All") {
                    return "All"
                } else {
                    return keyValue.0
                }
            }
            
        // If no exercises in workout, place it in the 'All' category.
        } else {
            return "All"
        }
    }

    // If no categories take up over 50% of the workout, assume it is an 'All Body' workout.
    return "All"
}
