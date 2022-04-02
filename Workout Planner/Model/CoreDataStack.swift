//
//  CoreDataStack.swift
//  Workout PlannerTests
//
//  https://www.raywenderlich.com/11349416-unit-testing-core-data-in-ios
//

import Foundation
import CoreData

open class CoreDataStack {
    public static let modelName = "WorkoutPlanner"

    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public init() { }

    public lazy var testContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()

    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName,
                                              managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }

    public func saveContext() {
        saveContext(testContext)
    }

    public func saveContext(_ context: NSManagedObjectContext) {
        if context != testContext {
            saveDerivedContext(context)
            return
        }

        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
                } catch let error as NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.saveContext(self.testContext)
        }
    }
}
