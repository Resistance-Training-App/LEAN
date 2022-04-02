//
//  LoadDefaultWorkouts.swift
//  WatchWorkoutPlanner Extension
//

import Foundation
import CoreData

func loadDefaultWorkouts(viewContext: NSManagedObjectContext) -> () {

    let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
    do {
        let workouts = try viewContext.fetch(fetchRequest) as [Workout]
        if (workouts.isEmpty) {
        
            if let url = Bundle.main.url(forResource: "Workouts", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Workout.DefaultWorkouts.self, from: data)
                    for workout in jsonData.defaultWorkout {
                        let newWorkout = Workout(context: viewContext)
                        newWorkout.id = UUID()
                        newWorkout.isFavourite = workout.isFavourite
                        newWorkout.name = workout.name
                        newWorkout.sets = workout.sets
                        newWorkout.timeCreated = Date()
                        newWorkout.isCopy = workout.isCopy

                        let exerciseFetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                        let exercises = try viewContext.fetch(exerciseFetchRequest) as [Exercise]
                        var newExercises: [Exercise] = []

                        for exercise in exercises {
                            let newExercise = Exercise(context: viewContext)
                            newExercise.id = UUID()
                            newExercise.order = exercise.order
                            newExercise.name = exercise.name
                            if (exercise.isHold) {
                                newExercise.repTime = 5
                            } else {
                                newExercise.repTime = exercise.repTime
                            }
                            newExercise.desc = exercise.desc
                            newExercise.tutorial = exercise.tutorial
                            newExercise.isFavourite = exercise.isFavourite
                            newExercise.isHold = exercise.isHold
                            newExercise.isLearnt = exercise.isLearnt
                            newExercise.isRotation = exercise.isRotation
                            newExercise.userCreated = exercise.userCreated
                            newExercise.category = exercise.category
                            newExercise.equipment = exercise.equipment

                            let newWeight = Weight(context: viewContext)
                            newWeight.order = 0
                            newWeight.count = Double.random(in: 1..<30)
                            newExercise.weight = NSSet.init(array: [newWeight])

                            let newReps = Reps(context: viewContext)
                            newReps.order = 0
                            newReps.count = Double.random(in: 1..<30)
                            newExercise.reps = NSSet.init(array: [newReps])

                            newExercises.append(newExercise)
                        }

                        let stretchFetchRequest: NSFetchRequest<Stretch> = Stretch.fetchRequest()
                        let stretches = (try viewContext.fetch(stretchFetchRequest) as [Stretch]).prefix(3)
                        var newStretches: [Stretch] = []
                        var counter = 0
                        if (newWorkout.name == "MyWorkout2" || newWorkout.name == "MyWorkout3") {
                            for stretch in stretches {
                                let newStretch = Stretch(context: viewContext)
                                newStretch.id = UUID()
                                newStretch.order = Int64(counter)
                                newStretch.name = stretch.name
                                newStretch.repTime = 10
                                newStretch.category = stretch.category
                                newStretch.type = StretchPeriod.warmUp.id
                                newStretches.append(newStretch)
                                counter += 1
                            }
                            newWorkout.warmUp = StretchLength.short.id
                        } else {
                            newWorkout.warmUp = StretchLength.none.id
                        }
                        counter = 0
                        if (newWorkout.name == "MyWorkout1" || newWorkout.name == "MyWorkout3") {
                            for stretch in stretches {
                                let newStretch = Stretch(context: viewContext)
                                newStretch.id = UUID()
                                newStretch.order = Int64(counter)
                                newStretch.name = stretch.name
                                newStretch.repTime = 10
                                newStretch.category = stretch.category
                                newStretch.type = StretchPeriod.coolDown.id
                                newStretches.append(newStretch)
                                counter += 1
                            }
                            newWorkout.coolDown = StretchLength.short.id
                        } else {
                            newWorkout.coolDown = StretchLength.none.id
                        }

                        newWorkout.stretches = NSSet.init(array: newStretches)
                        
                        let workoutExercises = Array(newExercises.shuffled().dropLast(10))
                        
                        newWorkout.category = mostCommonCategory(exercises: workoutExercises)
                        newWorkout.exercises = NSSet.init(array: workoutExercises)
                        newWorkout.time = calcTimeWorkout(workout: newWorkout)
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
