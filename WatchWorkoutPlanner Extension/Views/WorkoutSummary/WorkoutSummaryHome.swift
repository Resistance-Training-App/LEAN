//
//  WorkoutSummaryHome.swift
//  WorkoutSummaryHome
//
//  View displayed when a user has finished a workout detailing simple statistics and a list of
//  exercises they had completed.
//

import SwiftUI
import HealthKit

struct WorkoutSummaryHome: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile
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

    @State private var showExercises = false
    
    var body: some View {
        ScrollView {

            HStack {
                
                // Workout icon.
                if (!workout.justWorkout) {
                    WorkoutIcon(exercises: workout.myWorkout.exerciseArray, size: 60)
                } else {
                    Text("Open Workout")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                }
                Spacer()
                
                // User's activity rings.
                // Explanation: https://www.apple.com/uk/watch/close-your-rings/
                ActivityRings(healthStore: workout.healthStore)
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 15)
            }
            .if(workout.justWorkout) {
                $0.padding(.bottom)
            }

            VStack {
                if (!workout.justWorkout) {
                    HStack {
                        
                        // Workout name
                        Text(workout.myWorkout.name ?? "")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                        
                        Spacer()
                    }
                    HStack {
                        
                        // Estimate of the type of workout based on the exercises it includes.
                        Text(workout.myWorkout.category ?? "" == "All" ? "All Body" :
                             workout.myWorkout.category ?? "")
                            .font(.system(size: 15, weight: .regular, design: .default))
                        Spacer()
                    }
                }
            }
            
            // Only display the workout stats once loaded.
            if (workout.appleWorkout != nil) {
                WorkoutStats()
            } else {
                ProgressView()
                    .padding(.bottom, 100)
            }
           
            // Button to show or hide the list of exercises in the workout.
            Button(action: {
                showExercises.toggle()
            }) {
                HStack {
                    Text("EXERCISES")
                        .font(.caption)
                    Spacer()
                    Image(systemName: showExercises ? "chevron.down" : "chevron.right")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.white)
            .padding(.bottom, 15)
            
            // List of exercises in the workout completed.
            if (showExercises && !workout.justWorkout) {
                ForEach(0..<workout.myWorkout.exerciseArray.count, id: \.self) { i in
                    WorkoutSummaryExerciseRow(exercise: workout.myWorkout.exerciseArray[i],
                                              index: i)
                }
            }

            // List of exercises completed in an open workout.
            if (showExercises && workout.justWorkout) {
                ForEach(0..<removeDuplicateExercises(exercises: motion.exerciseResults).count, id: \.self) { i in
                    WorkoutSummaryExerciseRow(exercise: filteredExercises.filter {
                        $0.name == addSpaces(text: removeDuplicateExercises(exercises: motion.exerciseResults)[i]) }.first!,
                                              index: i)
                }
            }

            // Button to exit the workout summary.
            Button {
                workout.showingSummaryView = false
                workout.showingStretchingHome = false
                workout.showingWorkoutHome = false

                removeDuplicateMetrics(motion: motion, viewContext: viewContext)
            } label: {
                Text("Done")
            }
            .buttonStyle(.borderedProminent)
            .padding([.top, .bottom])

        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .padding(.top, 1)
        
        // Return to the list of workouts if the user presses the digital crown when viewing the
        // workout summary.
        .onDisappear {
            workout.showingStretchingHome = false
            workout.showingWorkoutHome = false
            workout.showingCountdown = false
            workout.justWorkout = false
            motion.justWorkout = false
            motion.exerciseResults.removeAll()
            removeDuplicateMetrics(motion: motion, viewContext: viewContext)
        }
        // Save the workout.
        .task {
            addWorkoutHistory(workout: workout,
                              motion: motion,
                              profile: profile,
                              exercises: filteredExercises,
                              viewContext: viewContext)
        }
    }
}
