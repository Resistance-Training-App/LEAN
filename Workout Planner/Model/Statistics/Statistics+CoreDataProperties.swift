//
//  Statistics+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension Statistics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Statistics> {
        return NSFetchRequest<Statistics>(entityName: "Statistics")
    }

    @NSManaged public var workouts: Int64
    @NSManaged public var time: Double
    @NSManaged public var reps: Int64
    @NSManaged public var longestWorkout: Double
    @NSManaged public var profile: Profile?

}

extension Statistics : Identifiable {

}
