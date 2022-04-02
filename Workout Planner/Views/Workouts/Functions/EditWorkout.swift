//
//  EditWorkout.swift
//  Workout Planner
//
//  Edits the attributes of an existing workout.
//

import Foundation
import CoreData

func editWorkout(showEdit: inout Bool,
                 workoutData: inout Workout.Template,
                 myWorkout: Workout,
                 deletedExercises: inout [Exercise],
                 viewContext: NSManagedObjectContext) {

    showEdit = false

    // Re-calculate the estimated workout time.
    workoutData.time = calcTimeWorkout(newWorkoutData: workoutData)
    
    // Delete exercises from the database that were removed from the workout.
    myWorkout.update(from: workoutData)
    for exercise in deletedExercises {
        viewContext.delete(exercise)
    }
    
    let exercisesArray = workoutData.exercises.sortedArray(using:
                         [NSSortDescriptor(keyPath: \Exercise.order,
                                           ascending: true)]) as! [Exercise]
    
    // Verify that the order of the exercises remains correct.
    if (workoutData.exercises.count > 1) {

        exercisesArray[0].order = 0
        for i in 1...exercisesArray.count-1 {
            exercisesArray[i].order = Int64(exercisesArray[i-1].order + 1)
        }
        myWorkout.exercises = NSSet(array: exercisesArray)

    } else if (workoutData.exercises.count == 1) {
        (myWorkout.exercises!.anyObject() as! Exercise).order = 0
    }
    
    // Update workout body category.
    myWorkout.category = mostCommonCategory(exercises: exercisesArray)
    
    // Delete all stretches before adding them again.
    for stretch in myWorkout.stretches?.allObjects as! [Stretch] {
        viewContext.delete(stretch)
    }
    
    // Add stretches
    do {
        let fetchStretchRequest: NSFetchRequest<Stretch> = Stretch.fetchRequest()
        let stretches = (try viewContext.fetch(fetchStretchRequest) as [Stretch]).filter{ $0.isCopy == false }
        let stretchesToAdd: NSMutableSet = NSMutableSet.init()
        let stretchTypes: [StretchPeriod:StretchLength] =
            [StretchPeriod.warmUp:workoutData.warmUp,
             StretchPeriod.coolDown:workoutData.coolDown]

        // Iterate through each stretching period (warm-up, cool-down).
        for stretchType in stretchTypes {
            if (stretchType.value != StretchLength.none) {
                    
                // Add all types of stretches if workout is all body.
                if (myWorkout.category! == Category.all.id) {
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
                
                // Only add relevant stretches if the workout focuses on a
                // particular part of the body.
                } else {
                    var orderIndex: Int64 = 0
                    
                    // Iterate through each stretch stored.
                    for stretch in stretches {
                        if (myWorkout.category == stretch.category) {
                            let newStretch = Stretch(context: viewContext)
                            newStretch.id = UUID()
                            newStretch.order = orderIndex
                            newStretch.name = stretch.name
                            newStretch.category = stretch.category
                            newStretch.picture = stretch.picture
                            newStretch.type = stretchType.key.id
                            newStretch.isCopy = true
                        
                            // Alter the length of the stretch based on how long
                            // they configured their warm-up/cool-down to be.
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
        myWorkout.stretches = stretchesToAdd.copy() as? NSSet
        myWorkout.warmUp = workoutData.warmUp.id
        myWorkout.coolDown = workoutData.coolDown.id
        myWorkout.time = calcTimeWorkout(workout: myWorkout)
    } catch let error {
        print("error FetchRequest \(error)")
    }

    do { try viewContext.save() } catch {
        print(error.localizedDescription)
    }
    PersistenceController.shared.save()

    deletedExercises.removeAll()
    
    workoutData = Workout.Template()
}
