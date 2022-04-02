//
//  WorkoutHistoryHome.swift
//  Workout Planner
//
//  Displays a list of workouts completed in reverse chronological order with the ability to delete
//  workouts.
//

import SwiftUI

struct WorkoutHistoryHome: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var profile: Profile

    var workoutHistories: [WorkoutHistory]

    var body: some View {
        
        // List of workouts completed.
        List {
            ForEach(workoutHistories) { workoutHistory in
                NavigationLink(destination:
                                WorkoutHistorySummaryHome(workoutHistory: workoutHistory)) {
                    WorkoutHistoryRow(workoutHistory: workoutHistory)
                }
                
                // Allows the user to delete a workout.
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        removeWorkoutHistory(workoutHistory: workoutHistory,
                                             profile: profile,
                                             viewContext: viewContext)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .navigationTitle("History")
    }
}
