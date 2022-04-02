//
//  LoadDefaults.swift
//  Workout Planner
//
//  Loads the default exercises and stretches into the app when the app is opened for the first time.
//

import Foundation
import CoreData

func loadDefaults(viewContext: NSManagedObjectContext) -> () {
    
    // Wait 10 seconds to allow exercises to load if they have already been added before.
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        
        // Load default exercises.
        let fetchExerciseRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            let exercises = try viewContext.fetch(fetchExerciseRequest) as [Exercise]

            if (exercises.isEmpty) {

                // Load default exercises.
                if let url = Bundle.main.url(forResource: "Exercises", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(Exercise.DefaultExercises.self,
                                                          from: data)
                        
                        // Create exercise object and add attributes.
                        for exercise in jsonData.defaultExercise {
                            let newExercise = Exercise(context: viewContext)
                            newExercise.id = UUID()
                            newExercise.order = exercise.order
                            newExercise.name = exercise.name
                            newExercise.repTime = exercise.repTime
                            newExercise.desc = exercise.desc
                            newExercise.tutorial = exercise.tutorial
                            newExercise.isFavourite = exercise.isFavourite
                            newExercise.isHold = exercise.isHold
                            newExercise.weight = NSSet.init()
                            newExercise.reps = NSSet.init()
                            newExercise.isLearnt = exercise.isLearnt
                            newExercise.isRotation = exercise.isRotation
                            newExercise.userCreated = exercise.userCreated
                            newExercise.category = exercise.category
                            newExercise.equipment = exercise.equipment
                        }
                    } catch {
                        print("error:\(error)")
                    }
                }
                
                // Load default stretches.
                if let url = Bundle.main.url(forResource: "Stretches", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(Stretch.DefaultStretches.self,
                                                          from: data)
                        
                        // Create stretch object and add attributes.
                        for stretch in jsonData.defaultStretches {
                            let newStretch = Stretch(context: viewContext)
                            newStretch.id = UUID()
                            newStretch.name = stretch.name
                            newStretch.category = stretch.category
                            newStretch.isCopy = false
                        }
                    } catch {
                        print("error:\(error)")
                    }
                }
            }
        } catch let error {
            print("error FetchRequest \(error)")
        }

        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
