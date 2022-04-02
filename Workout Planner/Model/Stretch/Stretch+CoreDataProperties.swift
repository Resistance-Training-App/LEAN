//
//  Stretch+CoreDataProperties.swift
//  Stretch
//
//

import Foundation
import CoreData


extension Stretch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stretch> {
        return NSFetchRequest<Stretch>(entityName: "Stretch")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isCopy: Bool
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var picture: Data?
    @NSManaged public var repTime: Double
    @NSManaged public var type: String?
    @NSManaged public var workout: Workout?

}

extension Stretch : Identifiable {

}

public enum StretchPeriod: String, CaseIterable, Identifiable {
    case warmUp = "Warm-up"
    case coolDown = "Cool-down"
    
    public var id: String { self.rawValue }
}
