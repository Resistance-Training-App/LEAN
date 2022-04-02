//
//  CreateNewWorkout.swift
//  Workout Planner
//
//  Creates a new workout.
//

import Foundation
import CoreData

func createNewWorkout(showNewWorkout: inout Bool,
                      newWorkoutData: inout Workout.Template,
                      viewContext: NSManagedObjectContext) {
    
    // Workout object
    let newWorkout = Workout(context: viewContext)
    newWorkout.id = UUID()
    newWorkout.name = newWorkoutData.name
    newWorkout.isFavourite = newWorkoutData.isFavourite
    newWorkout.sets = Int64(newWorkoutData.sets)
    newWorkout.addToExercises(newWorkoutData.exercises)
    newWorkout.timeCreated = Date()
    newWorkout.isCopy = false
    newWorkout.category = mostCommonCategory(exercises:
                          newWorkoutData.exercises.allObjects as! [Exercise])

    // Add stretches
    do {
        let fetchStretchRequest: NSFetchRequest<Stretch> = Stretch.fetchRequest()
        let stretches = (try viewContext.fetch(fetchStretchRequest) as [Stretch]).filter{ $0.isCopy == false }
        let stretchesToAdd: NSMutableSet = NSMutableSet.init()
        let stretchTypes: [StretchPeriod:StretchLength] =
            [StretchPeriod.warmUp:newWorkoutData.warmUp,
             StretchPeriod.coolDown:newWorkoutData.coolDown]

        // Iterate through each stretching period (warm-up, cool-down).
        for stretchType in stretchTypes {
            if (stretchType.value != StretchLength.none) {
                    
                // Add all types of stretches if workout is all body.
                if (newWorkout.category! == Category.all.id) {
                    var orderIndex: Int64 = 0
                    for category in Category.allCases {
                        if (category != Category.all) {
                            
                            let stretches = stretches.filter{
                                $0.category! == category.id }.prefix(2)
                            
                            for stretch in stretches {
                                let newStretch = Stretch(context: viewContext)
                                newStretch.id = UUID()
                                newStretch.order = orderIndex
                                newStretch.name = stretch.name
                                newStretch.category = stretch.category
                                newStretch.picture = stretch.picture
                                newStretch.type = stretchType.key.id
                                newStretch.isCopy = true
                            
                                // Alter the length of the stretch based on
                                // how long they configured their
                                // warm-up/cool-down to be.
                                switch stretchType.value {
                                    case StretchLength.short:
                                        newStretch.repTime = 10
                                    case StretchLength.medium:
                                        newStretch.repTime = 20
                                    case StretchLength.long:
                                        newStretch.repTime = 30
                                    default:
                                        ()
                                }
                                stretchesToAdd.add(newStretch)
                                orderIndex += 1
                            }
                        }
                    }
                
                // Only add relevant stretches if the workout focuses on
                // a particular part of the body.
                } else {
                    var orderIndex: Int64 = 0
                    
                    // Iterate through each stretch stored.
                    for stretch in stretches {
                        if (newWorkout.category == stretch.category) {
                            print(orderIndex)
                            let newStretch = Stretch(context: viewContext)
                            newStretch.id = UUID()
                            newStretch.order = orderIndex
                            newStretch.name = stretch.name
                            newStretch.category = stretch.category
                            newStretch.picture = stretch.picture
                            newStretch.type = stretchType.key.id
                            newStretch.isCopy = true
                        
                            // Alter the length of the stretch based on
                            // how long they configured their
                            // warm-up/cool-down to be.
                            switch stretchType.value {
                                case StretchLength.short:
                                    newStretch.repTime = 10
                                case StretchLength.medium:
                                    newStretch.repTime = 20
                                case StretchLength.long:
                                    newStretch.repTime = 30
                                default:
                                    ()
                            }
                            stretchesToAdd.add(newStretch)
                            orderIndex += 1
                        }
                    }
                }
            }
        }
        newWorkout.stretches = stretchesToAdd.copy() as? NSSet
        newWorkout.warmUp = newWorkoutData.warmUp.id
        newWorkout.coolDown = newWorkoutData.coolDown.id
        newWorkout.time = calcTimeWorkout(workout: newWorkout)

    } catch let error {
        print("error FetchRequest \(error)")
    }
    
    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()

    newWorkoutData = Workout.Template()
    showNewWorkout = false
}
