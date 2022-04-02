//
//  Workout+CoreDataProperties.swift
//  Workout
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var category: String?
    @NSManaged public var coolDown: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isCopy: Bool
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String?
    @NSManaged public var sets: Int64
    @NSManaged public var time: Double
    @NSManaged public var timeCreated: Date?
    @NSManaged public var warmUp: String?
    @NSManaged public var exercises: NSSet?
    @NSManaged public var stretches: NSSet?
    @NSManaged public var workoutHistories: NSSet?
    
    var exerciseArray: [Exercise] {
        get {
            if let exercises = exercises {
                return (exercises.allObjects as! [Exercise]).sorted() {
                    $1.order > $0.order
                }
            }
            return [Exercise]()
        }
    }
    
    var stretchArray: [Stretch] {
        get {
            if let stretches = stretches {
                return (stretches.allObjects as! [Stretch]).sorted() {
                    $1.order > $0.order
                }
            }
            return [Stretch]()
        }
    }

}

// MARK: Generated accessors for exercises
extension Workout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

// MARK: Generated accessors for stretches
extension Workout {

    @objc(addStretchesObject:)
    @NSManaged public func addToStretches(_ value: Stretch)

    @objc(removeStretchesObject:)
    @NSManaged public func removeFromStretches(_ value: Stretch)

    @objc(addStretches:)
    @NSManaged public func addToStretches(_ values: NSSet)

    @objc(removeStretches:)
    @NSManaged public func removeFromStretches(_ values: NSSet)

}

// MARK: Generated accessors for workoutHistories
extension Workout {

    @objc(addWorkoutHistoriesObject:)
    @NSManaged public func addToWorkoutHistories(_ value: WorkoutHistory)

    @objc(removeWorkoutHistoriesObject:)
    @NSManaged public func removeFromWorkoutHistories(_ value: WorkoutHistory)

    @objc(addWorkoutHistories:)
    @NSManaged public func addToWorkoutHistories(_ values: NSSet)

    @objc(removeWorkoutHistories:)
    @NSManaged public func removeFromWorkoutHistories(_ values: NSSet)

}

extension Workout : Identifiable {

    struct Template {
        var name: String = ""
        var isFavourite: Bool = false
        var sets: Double = 1.0
        var exercises: NSSet = NSSet.init()
        var time: Double = 1.0
        var warmUp: StretchLength = StretchLength.none
        var coolDown: StretchLength = StretchLength.none
    }

    var template: Template {
        return Template(name: name ?? "",
                        isFavourite: isFavourite,
                        sets: Double(sets),
                        exercises: exercises ?? NSSet.init(),
                        time: time,
                        warmUp: StretchLength(rawValue: warmUp!)!,
                        coolDown: StretchLength(rawValue: coolDown!)!)
    }
    
    func update(from template: Template) {
        self.name = template.name
        self.isFavourite = template.isFavourite
        self.sets = Int64(template.sets)
        self.exercises = template.exercises
        self.time = template.time
    }
}

public enum Length: String, CaseIterable, Identifiable {
    case all, short, medium, long
    public var id: String { self.rawValue }
}

public enum SortType: String, CaseIterable, Identifiable {
    case oldToNew, newToOld, timeAscending, timeDescending, setsAscending, setsDescending, aToZ
    public var id: String { self.rawValue }
}

public enum StretchLength: String, CaseIterable, Identifiable {
    case none = "None"
    case short = "Short"
    case medium = "Medium"
    case long = "Long"
    
    public var id: String { self.rawValue }
}
