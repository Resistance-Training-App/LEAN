//
//  WorkoutAddExerciseButton.swift
//  Workout Planner
//
//  Button to add an exercise to a workout.
//

import SwiftUI

struct WorkoutAddExerciseButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>
    
    @Binding var workoutData: Workout.Template
    @Binding var showConfirmation: Bool

    var newExerciseName: String
    var newExerciseWeight: [Double]
    var newExerciseReps: [Double]
    var newExerciseRepTime: Double
    var addToStart: Bool

    var body: some View {
        let buttonLabel = addToStart ? "Add Exercise\nto start" : "Add Exercise\nto end"
        let isDisabled: Bool = newExerciseName.count > 0 ? false : true
    
        Button {
            // Finds the exercise object and creates a copy of it with attributes such as weight and
            // reps modified.
            let exercise: Exercise = exercises.first(where: {$0.name == newExerciseName})!

            let newExercise = Exercise(context: viewContext)
            newExercise.id = UUID()
            newExercise.name = exercise.name
            newExercise.repTime = newExerciseRepTime
            newExercise.desc = exercise.desc
            newExercise.tutorial = exercise.tutorial
            newExercise.isFavourite = exercise.isFavourite
            newExercise.isHold = exercise.isHold
            newExercise.picture = UIImage(data: exercise.picture ?? Data.init())?.pngData()
                                  ?? UIImage().pngData()
            newExercise.isLearnt = exercise.isLearnt
            newExercise.isRotation = exercise.isRotation
            newExercise.userCreated = false
            newExercise.category = exercise.category
            newExercise.equipment = exercise.equipment
            
            let weightsToAdd: NSMutableSet = NSMutableSet.init()
            var orderIndex = 0
            for weight in newExerciseWeight {
                let newWeight = Weight(context: viewContext)
                newWeight.count = weight
                newWeight.order = Int64(orderIndex)
                weightsToAdd.add(newWeight)
                orderIndex += 1
            }
            newExercise.weight = weightsToAdd.copy() as? NSSet

            let repsToAdd: NSMutableSet = NSMutableSet.init()
            orderIndex = 0
            for reps in newExerciseReps {
                let newReps = Reps(context: viewContext)
                newReps.count = reps
                newReps.order = Int64(orderIndex)
                repsToAdd.add(newReps)
                orderIndex += 1
            }
            newExercise.reps = repsToAdd.copy() as? NSSet

            // Adds the exercise to the array of exercises in the workout.
            let mutableExercises = workoutData.exercises.mutableCopy() as! NSMutableSet
            let exercisesArray = workoutData.exercises.sortedArray(using:
                                 [NSSortDescriptor(keyPath: \Exercise.order,
                                                   ascending: true)]) as! [Exercise]
            
            // Add the exercise to the start of the workout.
            if (addToStart) {
                newExercise.order = 0
                for exercise in mutableExercises {
                    (exercise as! Exercise).order += 1
                }
                mutableExercises.add(newExercise)
                
            // Add the exercise to the end of the workout.
            } else {
                newExercise.order = Int64((exercisesArray.last?.order ?? -1)+1)
                mutableExercises.add(newExercise)
            }
            workoutData.exercises = mutableExercises.copy() as! NSSet

            // Displays a confirmation box for two seconds when the exercise is added.
            showConfirmation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfirmation = false
            }
        } label: {
            Text(buttonLabel)
                .font(.system(size: 20))
                .fontWeight(.semibold)
        }
        .padding([.leading, .trailing])
        .padding([.top, .bottom], 5)
        .background(Color.orange)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
        .disabled(isDisabled)
    }
}
