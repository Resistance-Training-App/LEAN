//
//  WorkoutHistory+CoreDataProperties.swift
//  WorkoutHistory
//
//

import Foundation
import CoreData

extension WorkoutHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutHistory> {
        return NSFetchRequest<WorkoutHistory>(entityName: "WorkoutHistory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var avgHeartRate: Double
    @NSManaged public var calories: Double
    @NSManaged public var isJustWorkout: Bool
    @NSManaged public var workout: Workout?

}

extension WorkoutHistory : Identifiable {

}
