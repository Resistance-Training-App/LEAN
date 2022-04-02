//
//  Metrics+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension Metrics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Metrics> {
        return NSFetchRequest<Metrics>(entityName: "Metrics")
    }

    @NSManaged public var repCount: Int64
    @NSManaged public var order: Int64
    @NSManaged public var results: [String]?
    @NSManaged public var repStartTimes: [Double]?
    @NSManaged public var repEndTimes: [Double]?
    @NSManaged public var repRangeOfMotions: [Double]?
    @NSManaged public var repMiddleTimes: [Double]?
    @NSManaged public var weightChoice: Double
    @NSManaged public var exercise: Exercise?

}

extension Metrics : Identifiable {

}
