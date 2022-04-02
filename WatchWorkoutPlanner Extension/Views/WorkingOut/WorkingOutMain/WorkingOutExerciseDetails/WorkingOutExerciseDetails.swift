//
//  WorkingOutExerciseDetails.swift
//  WorkingOutExerciseDetails
//
//  View displays details about the current exercise (Weight, reps and equipment).
//

import SwiftUI
import CoreData

struct WorkingOutExerciseDetails: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager

    var body: some View {
        ZStack {

            // Background
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(white: 0.1))
                .frame(maxWidth: .infinity, maxHeight: 30)

            HStack {
                Spacer()

                // The weight of the current exercise.
                VStack {
                    HStack {
                        Text(String(format: workout.myWorkout.exerciseArray[workout.currentExercise].weightArray[workout.currentExerciseSet].count.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", workout.myWorkout.exerciseArray[workout.currentExercise].weightArray[workout.currentExerciseSet].count))
                            .font(Font.bold(Font.system(size: 500))())
                            .minimumScaleFactor(0.01)
                        Text(profile.weightUnit ?? "")
                            .font(Font.bold(Font.system(size: 12))())
                    }
                }
                .frame(width: 60, height: 30, alignment: .center)
                .padding(.bottom, 1)
                
                Spacer()
                
                // The equipment required for the current exercise.
                if (workout.myWorkout.exerciseArray[workout.currentExercise].equipment ?? "" != "All") {
                    Image("\(workout.myWorkout.exerciseArray[workout.currentExercise].equipment ?? "")Light")
                        .resizable()
                        .frame(width: 45, height: 30, alignment: .center)
                }

                Spacer()

                HStack {
                    Spacer()
                    // The number of reps of the current exercise.
                    if workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt {
                        Text("\(String(motion.repCount))/\(String(format: "%.0f", workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[workout.currentExerciseSet].count))")
                            .font(Font.bold(Font.system(size: 500))())
                            .minimumScaleFactor(0.01)
                            .if(Double(motion.repCount) >= workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[workout.currentExerciseSet].count) {
                                $0.foregroundColor(.green)
                            }
                    } else {
                        Text(String(format: "%.0f", workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[workout.currentExerciseSet].count))
                            .font(Font.bold(Font.system(size: 500))())
                            .minimumScaleFactor(0.01)
                    }
                    Spacer()
                }
                .frame(width: 60, height: 30, alignment: .center)
                .padding(.bottom, 1)
                
                Spacer()
            }
        }

        // Let the user know they have one more rep to go.
        .onChange(of: motion.repCount, perform: { value in
            if (Double(value + 1) == workout.myWorkout.exerciseArray[workout.currentExercise].repsArray[workout.currentExerciseSet].count) {
                WKInterfaceDevice.current().play(.success)
            }
        })
    }
}
