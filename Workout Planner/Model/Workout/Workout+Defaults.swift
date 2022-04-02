//
//  Workout+Defaults.swift
//  Workout+Defaults
//

import Foundation
import CoreData

extension Workout {
    
    struct DefaultWorkouts: Decodable {
        var defaultWorkout: [DefaultWorkout]
    }

    struct DefaultWorkout: Decodable {
        var isFavourite: Bool = false
        var name: String
        var sets: Int64
        var time: Double
        var isCopy: Bool = false
    }
}
