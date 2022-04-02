//
//  TestCoreDataStack.swift
//  Workout PlannerTests
//
//  https://www.raywenderlich.com/11349416-unit-testing-core-data-in-ios
//

import CoreData
import Workout_Planner

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentContainer(
      name: CoreDataStack.modelName,
      managedObjectModel: CoreDataStack.model)

    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    storeContainer = container
  }
}
