//
//  WorkoutSummaryHome.swift
//  Workout Planner
//
//  View displayed when a user has finished a workout detailing simple statistics and a list of
//  exercises they had completed.
//

import SwiftUI

struct WorkoutSummaryHome: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile

    var body: some View {
        ScrollView {
            VStack {
                HStack {

                    // Workout icon
                    WorkoutIconGrid(exercises: workout.myWorkout.exerciseArray, size: 150)
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        // Workout name
                        Text(workout.myWorkout.name ?? "")
                            .font(.largeTitle).bold()
                            .lineLimit(2)

                        // Estimate of the type of workout based on the exercises it includes.
                        Text(workout.myWorkout.category ?? "" == "All" ? "All Body" :
                             workout.myWorkout.category ?? "")
                            .font(.title2)
                            .foregroundColor(.primary)

                        // Display which device the workout was run on.
                        Image(systemName: "iphone")

                        Spacer()
                    }
                    Spacer()
                }
                Spacer()

                // Box of simple statistics
                WorkoutSummaryBox()
                
                // List of exercises in the workout completed
                HStack {
                    Text("Exercises")
                        .font(.system(size: 25, weight: .semibold, design: .default))
                    Spacer()
                }
                ForEach(0..<workout.myWorkout.exerciseArray.count, id: \.self) { i in
                    WorkoutSummaryExerciseRow(exercise: workout.myWorkout.exerciseArray[i])
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            
            // Button to dismiss the workout summary.
            Button {
                workout.showingSummaryView = false
                workout.resetWorkout()
            } label: {
                Text("Done")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
        }

        // Save workout history.
        .task {
            addWorkoutHistory(workout: workout, profile: profile, viewContext: viewContext)
        }
        .navigationBarHidden(true)
    }
}
