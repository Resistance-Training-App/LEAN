//
//  LoadDefaultExercises.swift
//  WatchWorkoutPlanner Extension
//

import Foundation
import CoreData

func loadDefaultExercises(viewContext: NSManagedObjectContext) {

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
        } else {
            print("App already opened on account")
        }
    } catch let error {
        print("error FetchRequest \(error)")
    }
}
