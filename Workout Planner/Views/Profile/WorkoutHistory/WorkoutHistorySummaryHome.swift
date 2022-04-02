//
//  WorkoutHistorySummaryHome.swift
//  Workout Planner
//
//  View displayed when a user clicks on the workout in the history section in the profile
//  detailing statistics about the workout and a list of exercises they had completed.
//

import SwiftUI

struct WorkoutHistorySummaryHome: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var profile: Profile

    let workoutHistory: WorkoutHistory
    
    @State private var showingConfirmation = false

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    // Workout Icon
                    WorkoutIconGrid(exercises: workoutHistory.workout?.exerciseArray ?? [], size: 150)
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        // Workout name
                        Text(workoutHistory.workout?.name ?? "")
                            .font(.largeTitle).bold()
                            .lineLimit(2)

                        // Estimate of the type of workout based on the exercises it includes.
                        Text(workoutHistory.workout?.category ?? "" == "All" ? "All Body" :
                             workoutHistory.workout?.category ?? "")
                            .font(.title2)

                        // Time the workout was done.
                        Text(formatDate(date: workoutHistory.timestamp ?? Date()))
                            .font(.title3)

                        // Display which device the workout was run on.
                        if (workoutHistory.avgHeartRate > 0) {
                            Image(systemName: "applewatch")
                        } else {
                            Image(systemName: "iphone")
                        }
                        Spacer()
                    }
                    Spacer()
                }

                // Box of simple statistics
                WorkoutHistorySummaryBox(time: workoutHistory.time,
                                         workoutHistory: workoutHistory)

                // List of exercises in the workout completed
                HStack {
                    Text("Exercises")
                        .font(.system(size: 25, weight: .semibold, design: .default))
                    Spacer()
                }
                ForEach(0..<(workoutHistory.workout?.exercises?.count ?? 0), id: \.self) { i in
                    
                    // Only allow the exercise detail page to be opened if reps were counted.
                    if (workoutHistory.workout?.exerciseArray[i].isLearnt ?? false &&
                        (workoutHistory.workout?.exerciseArray[i].metricsArray.first?.repCount ?? 0) > 0) {
                        NavigationLink(destination:
                        WorkoutHistoryExerciseDetails(exercise: workoutHistory.workout?.exerciseArray[i] ?? Exercise.init(),
                                                      isJustWorkout: workoutHistory.isJustWorkout)) {
                            WorkoutSummaryExerciseRow(exercise: workoutHistory.workout?.exerciseArray[i] ?? Exercise.init(),
                                                      isJustWorkout: workoutHistory.isJustWorkout)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        WorkoutSummaryExerciseRow(exercise: workoutHistory.workout?.exerciseArray[i] ?? Exercise.init())
                    }
                }
            }
            .padding()
        }
        .navigationTitle(workoutHistory.workout?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems( trailing:

            // Button to delete the workout history.
            Button {
                showingConfirmation.toggle()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        )
        
        // Confirmation box before deleting the workout history.
        .confirmationDialog("Are you sure? (This will not delete the workout itself)",
                            isPresented: $showingConfirmation,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                withAnimation {
                    removeWorkoutHistory(workoutHistory: workoutHistory,
                                         profile: profile,
                                         viewContext: viewContext)
                }
            } label: {
                Text("Delete")
            }
        }
    }
}
