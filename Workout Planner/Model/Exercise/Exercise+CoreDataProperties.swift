//
//  Exercise+CoreDataProperties.swift
//  Exercise
//
//

import Foundation
import CoreData
import UIKit

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var equipment: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var isHold: Bool
    @NSManaged public var name: String?
    @NSManaged public var order: Int64
    @NSManaged public var picture: Data?
    @NSManaged public var repTime: Double
    @NSManaged public var tutorial: String?
    @NSManaged public var userCreated: Bool
    @NSManaged public var isLearnt: Bool
    @NSManaged public var isRotation: Bool
    @NSManaged public var workout: Workout?
    @NSManaged public var weight: NSSet?
    @NSManaged public var reps: NSSet?
    @NSManaged public var metrics: NSSet?
    
    var weightArray: [Weight] {
        get {
            if let weight = weight {
                return (weight.allObjects as! [Weight]).sorted() {
                    $1.order > $0.order
                }
            }
            return [Weight]()
        }
    }
    
    var repsArray: [Reps] {
        get {
            if let reps = reps {
                return (reps.allObjects as! [Reps]).sorted() {
                    $1.order > $0.order
                }
            }
            return [Reps]()
        }
    }
    
    var metricsArray: [Metrics] {
        get {
            if let metrics = metrics {
                return (metrics.allObjects as! [Metrics]).sorted() {
                    $1.order > $0.order
                }
            }
            return [Metrics]()
        }
    }

}

// MARK: Generated accessors for weight
extension Exercise {

    @objc(addWeightObject:)
    @NSManaged public func addToWeight(_ value: Weight)

    @objc(removeWeightObject:)
    @NSManaged public func removeFromWeight(_ value: Weight)

    @objc(addWeight:)
    @NSManaged public func addToWeight(_ values: NSSet)

    @objc(removeWeight:)
    @NSManaged public func removeFromWeight(_ values: NSSet)

}

// MARK: Generated accessors for reps
extension Exercise {

    @objc(addRepsObject:)
    @NSManaged public func addToReps(_ value: Reps)

    @objc(removeRepsObject:)
    @NSManaged public func removeFromReps(_ value: Reps)

    @objc(addReps:)
    @NSManaged public func addToReps(_ values: NSSet)

    @objc(removeReps:)
    @NSManaged public func removeFromReps(_ values: NSSet)

}

// MARK: Generated accessors for workouts
extension Exercise {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

// MARK: Generated accessors for metrics
extension Exercise {

    @objc(addMetricsObject:)
    @NSManaged public func addToMetrics(_ value: Metrics)

    @objc(removeMetricsObject:)
    @NSManaged public func removeFromMetrics(_ value: Metrics)

    @objc(addMetrics:)
    @NSManaged public func addToMetrics(_ values: NSSet)

    @objc(removeMetrics:)
    @NSManaged public func removeFromMetrics(_ values: NSSet)

}

extension Exercise: Identifiable {

    struct Template {
        var order: Int64 = 0
        var name: String = ""
        var repTime: Double = 1
        var desc: String = ""
        var tutorial: String = ""
        var isFavourite: Bool = false
        var isHold: Bool = false
        var userCreated: Bool = true
        var isLearnt: Bool = false
        var isRotation: Bool = false
        var picture: Data = Data.init()
        var category: String = Category.upperBody.rawValue
        var equipment: String = Equipment.bodyweight.rawValue
        var weight: NSSet = NSSet.init()
        var reps: NSSet = NSSet.init()
    }
    
    var template: Template {
        return Template(order: order,
                        name: name ?? "",
                        repTime: repTime,
                        desc: desc ?? "",
                        tutorial: tutorial ?? "",
                        isFavourite: isFavourite,
                        isHold: isHold,
                        userCreated: userCreated,
                        isLearnt: isLearnt,
                        isRotation: isRotation,
                        picture: picture ?? Data.init(),
                        category: category ?? "All",
                        equipment: equipment ?? "All",
                        weight: weight ?? NSSet.init(),
                        reps: reps ?? NSSet.init())
    }
    
    func update(from template: Template) {
        self.order = template.order
        self.name = template.name
        self.repTime = template.repTime
        self.desc = template.desc
        self.tutorial = template.tutorial
        self.isFavourite = template.isFavourite
        self.isHold = template.isHold
        self.userCreated = template.userCreated
        self.isLearnt = template.isLearnt
        self.isRotation = template.isRotation
        if (!template.picture.isEmpty) {
            self.picture = template.picture
        }
        self.category = template.category
        self.equipment = template.equipment
        self.weight = template.weight
        self.reps = template.reps
    }
}

public enum Category: String, Equatable, CaseIterable, Codable {
    case all = "All"
    case upperBody = "Upper Body"
    case core = "Core"
    case lowerBody = "Lower Body"
    
    var id: String { self.rawValue }
}

public enum Equipment: String, CaseIterable, Codable {
    case all = "All"
    case bodyweight = "Bodyweight"
    case dumbbells = "Dumbbells"
    case barbell = "Barbell"
    
    var id: String { self.rawValue }
}

public enum CreatedBy: String, CaseIterable, Codable {
    case all = "All"
    case `default` = "Default"
    case userCreated = "Custom"
    
    var id: String { self.rawValue }
}
