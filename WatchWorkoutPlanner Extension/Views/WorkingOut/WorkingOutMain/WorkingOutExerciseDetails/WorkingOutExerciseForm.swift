//
//  WorkingOutExerciseForm.swift
//  WatchWorkoutPlanner Extension
//
//  Displays the current form of the user when running an open workout.
//

import SwiftUI

struct WorkingOutExerciseForm: View {

    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var workout: WorkoutManager

    var body: some View {
        HStack {
            
            // Display prediction if the current model is a form analysis model.
            if (motion.modelManager.selectedModel != .Exercise) {
                Spacer()
                Text(addSpaces(text: (motion.results.last ?? "")))
                    .font(.title2).bold()
                    .if((motion.results.last ?? "") == "Good") {
                        $0.foregroundColor(.green)
                    }
                    .if((motion.results.last ?? "") != "Good") {
                        $0.foregroundColor(.red)
                    }
                Spacer()
                Text(String(motion.repCount))
                    .font(.title2).bold()
                Spacer()
            }
        }
        
        // Save exercise metrics if the user has stopped exercising.
        .onChange(of: motion.results.last ?? "", perform: { lastFormPrediction in
            if (motion.exerciseResults.count > 1 && lastFormPrediction == "Other" && motion.results.count > 1) {

                motion.results = Array(motion.results.filter({ $0 != "Other" }))
                
                // Save exercise set.
                if (motion.results.count > 2) {
                    
                    // Increment current exercise or current exercise set based on the last exercise.
                    if (motion.metrics.first != nil) {
                        let exercise1 = motion.exerciseResults.filter({ $0 != "Other" }).suffix(2).first ?? ""
                        let exercise2 = motion.exerciseResults.filter({ $0 != "Other" }).suffix(2).last ?? ""
                        
                        if (exercise1 == exercise2) {
                            workout.currentExerciseSet += 1
                        } else {
                            workout.currentExercise += 1
                            workout.currentExerciseSet = 0
                        }
                    }
                    
                    // Save exercise metrics.
                    saveMetrics(workout: workout, motion: motion, viewContext: viewContext)
                    motion.metrics[workout.currentExercise][workout.currentExerciseSet].weightChoice = workout.currentWeightChoice
                    
                // Discard false positive.
                } else {
                    if (motion.exerciseResults.last ?? "" != "Other") {
                        motion.exerciseResults.remove(at: motion.exerciseResults.count - 1)
                    } else {
                        motion.exerciseResults.remove(at: motion.exerciseResults.count - 1)
                        motion.exerciseResults.remove(at: motion.exerciseResults.count - 1)
                    }
                }
                
                // Remove all form prediction results.
                motion.results.removeAll()
            }
        })
    }
}
