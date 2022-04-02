//
//  Profile+CoreDataProperties.swift
//  Workout Planner
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var countdown: Double
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var picture: Data?
    @NSManaged public var formAdviceAlerts: Bool
    @NSManaged public var theme: String?
    @NSManaged public var weightUnit: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var personalBest: NSSet?
    @NSManaged public var statistics: Statistics?
    
    var personalBestArray: [PersonalBest] {
        get {
            if let personalBest = personalBest {
                return (personalBest.allObjects as! [PersonalBest]).sorted() {
                    $1.exerciseName ?? "" > $0.exerciseName ?? ""
                }
            }
            return [PersonalBest]()
        }
    }

}

// MARK: Generated accessors for personalBest
extension Profile {

    @objc(addPersonalBestObject:)
    @NSManaged public func addToPersonalBest(_ value: PersonalBest)

    @objc(removePersonalBestObject:)
    @NSManaged public func removeFromPersonalBest(_ value: PersonalBest)

    @objc(addPersonalBest:)
    @NSManaged public func addToPersonalBest(_ values: NSSet)

    @objc(removePersonalBest:)
    @NSManaged public func removeFromPersonalBest(_ values: NSSet)

}

extension Profile : Identifiable {

    struct Template {
        var firstName: String = ""
        var lastName: String = ""
        var email: String = ""
        var picture: Data = Data.init()
        var formAdviceAlerts = true
        var weightUnit: String = ""
        var theme: String = ""
        var countdown: Double = 3
    }

    var template: Template {
        return Template(firstName: firstName ?? "",
                        lastName: lastName ?? "",
                        email: email ?? "",
                        picture: picture ?? Data.init(),
                        formAdviceAlerts: formAdviceAlerts,
                        weightUnit: weightUnit ?? Units.kilograms.id,
                        theme: theme ?? Themes.system.id,
                        countdown: countdown)
    }
    
    func update(from template: Template) {
        self.firstName = template.firstName
        self.lastName = template.lastName
        self.email = template.email
        self.picture = template.picture
        self.formAdviceAlerts = template.formAdviceAlerts
        self.weightUnit = template.weightUnit
        self.theme = template.theme
        self.countdown = template.countdown
    }
}

enum Units: String, CaseIterable, Identifiable, Codable {
    case kilograms = "kg"
    case pounds = "lb"

    var id: String { self.rawValue }
}

enum Themes: String, CaseIterable, Identifiable, Codable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { self.rawValue }
}
