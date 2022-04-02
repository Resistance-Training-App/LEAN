//
//  WorkingOutExerciseDetails.swift
//  Workout Planner
//
//  Details of the current exercise including the weight, reps and equipment.
//

import SwiftUI
import CoreData

struct WorkingOutExerciseDetails: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var workout: WorkoutManager
    
    var body: some View {
        ZStack {

            // Rectangle to overlay the text on.
            RoundedRectangle(cornerRadius: 20)
                .fill(colourScheme == .dark ?
                        Color(white: 0.1) :
                        Color(white: 0.9))
                .frame(maxWidth: .infinity, maxHeight: 180)

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        
                        // The weight of the current exercise set.
                        Text("Weight")
                            .font(Font.system(size: 20))
                            .fontWeight(.semibold)

                        Text("\(String(format: workout.myWorkout.exerciseArray[workout.currentExercise].weightArray[workout.currentExerciseSet].count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", workout.myWorkout.exerciseArray[workout.currentExercise].weightArray[workout.currentExerciseSet].count)) \(profile.weightUnit ?? "")")
                            .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                            .frame(width: 100)
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        
                        // The number of reps of the current exercise set.
                        Text("Reps")
                            .font(Font.system(size: 20))
                            .fontWeight(.semibold)

                            Text(String(format: "%.0f", workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[workout.currentExerciseSet].count))
                                .font(Font.monospacedDigit(Font.system(size: 30).weight(.bold))())
                                .frame(width: 100)
                    }
                    Spacer()
                }
                
                // The equipment required for the current exercise.
                if (workout.myWorkout.exerciseArray[workout.currentExercise].equipment ?? "" != "All") {
                    Image(colourScheme == .dark ?
                          "\(workout.myWorkout.exerciseArray[workout.currentExercise].equipment ?? "")Light" :
                          "\(workout.myWorkout.exerciseArray[workout.currentExercise].equipment ?? "")Dark")
                        .resizable()
                        .frame(width: 100, height: 50, alignment: .center)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}
