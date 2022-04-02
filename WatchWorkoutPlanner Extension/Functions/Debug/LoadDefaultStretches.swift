//
//  LoadDefaultStretches.swift
//  WatchWorkoutPlanner Extension
//

import Foundation
import CoreData

func loadDefaultStretches(viewContext: NSManagedObjectContext) {

    let fetchExerciseRequest: NSFetchRequest<Stretch> = Stretch.fetchRequest()
    do {
        let stretches = try viewContext.fetch(fetchExerciseRequest) as [Stretch]

        if (stretches.isEmpty) {

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
}
