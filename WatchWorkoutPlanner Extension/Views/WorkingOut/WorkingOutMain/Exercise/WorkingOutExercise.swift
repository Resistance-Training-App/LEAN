//
//  WorkingOutExercise.swift
//  WorkingOutExercise
//
//  View displays the current and next exercise in the workout.
//

import SwiftUI
import CoreData

struct WorkingOutExercise: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>
    
    // The list of exercises to be displayed based on the filters selected.
    var filteredExercises: [Exercise] {

        var filteredExercises: [Exercise]

        filteredExercises = exercises.filter { exercise in
            exercise.reps?.count == 0
        }
        
        return filteredExercises
    }

    var body: some View {
        VStack {
            if (!workout.justWorkout) {
            
                // Current exercise in the workout.
                if (WKInterfaceDevice.current().screenBounds.height > 197) {
                    CircleImageExercise(exercise: workout.myWorkout.exerciseArray[workout.currentExercise],
                                        size: (workout.myWorkout.exerciseArray[workout.currentExercise].name ?? "").count < 11 ? 70 : 50.5,
                    showDetails: true)
                } else {
                    CircleImageExercise(exercise: workout.myWorkout.exerciseArray[workout.currentExercise],
                                        size: (workout.myWorkout.exerciseArray[workout.currentExercise].name ?? "").count < 11 ? 60 : 40.5,
                    showDetails: true)
                }

                // Current exercise name.
                Text(workout.myWorkout.exerciseArray[workout.currentExercise].name ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            } else {

                // Current predicated exercise.
                if (WKInterfaceDevice.current().screenBounds.height > 197) {
                    CircleImageExercise(exercise: filteredExercises.filter {
                        $0.name == addSpaces(text: (motion.exerciseResults.last ?? "Rest" == "Other") ? "Rest" : motion.exerciseResults.last ?? "Rest") }.first!,
                                        size: (addSpaces(text: motion.exerciseResults.last ?? "")).count < 11 ? 70 : 50.5,
                                        showDetails: true)
                } else {
                    CircleImageExercise(exercise: filteredExercises.filter {
                        $0.name == addSpaces(text: (motion.exerciseResults.last ?? "Rest" == "Other") ? "Rest" : motion.exerciseResults.last ?? "Rest") }.first!,
                                        size: (addSpaces(text: motion.exerciseResults.last ?? "")).count < 11 ? 60 : 40.5,
                                        showDetails: true)
                }

                // Current predicated exercise name.
                Text(addSpaces(text: (motion.exerciseResults.last ?? "Rest" == "Other") ? "Rest" : motion.exerciseResults.last ?? "Rest"))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: WKInterfaceDevice.current().screenBounds.width/2,
               height: WKInterfaceDevice.current().screenBounds.height/3)
        .if(workout.justWorkout) {
            $0.padding(.top, 40)
        }
    }
}
