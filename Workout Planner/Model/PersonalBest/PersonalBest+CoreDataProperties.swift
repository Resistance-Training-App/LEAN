//
//  PersonalBest+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension PersonalBest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalBest> {
        return NSFetchRequest<PersonalBest>(entityName: "PersonalBest")
    }

    @NSManaged public var exerciseName: String?
    @NSManaged public var weight: Double
    @NSManaged public var profile: Profile?

}

extension PersonalBest : Identifiable {

}
