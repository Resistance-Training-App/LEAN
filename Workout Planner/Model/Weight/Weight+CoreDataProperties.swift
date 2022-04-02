//
//  Weight+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var count: Double
    @NSManaged public var order: Int64
    @NSManaged public var exercise: Exercise?

}

extension Weight : Identifiable {

}
