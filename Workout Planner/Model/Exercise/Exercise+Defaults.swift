//
//  Exercise+Defaults.swift
//  Exercise+Defaults
//

import Foundation
import CoreData

extension Exercise {
    
    struct DefaultExercises: Decodable {
        var defaultExercise: [DefaultExercise]
    }

    struct DefaultExercise: Decodable {
        var order: Int64
        var name: String
        var repTime: Double
        var desc: String
        var tutorial: String
        var isFavourite: Bool = false
        var isHold: Bool
        var userCreated: Bool = false
        var isLearnt: Bool
        var isRotation: Bool
        var category: String
        var equipment: String
    }
}
