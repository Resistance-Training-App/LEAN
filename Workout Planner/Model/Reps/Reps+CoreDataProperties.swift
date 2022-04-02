//
//  Reps+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension Reps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reps> {
        return NSFetchRequest<Reps>(entityName: "Reps")
    }

    @NSManaged public var count: Double
    @NSManaged public var order: Int64
    @NSManaged public var exercise: Exercise?

}

extension Reps : Identifiable {

}
