//
//  WorkoutHistoryPreview.swift
//  Workout Planner
//
//  Displays the three most recent workouts completed.
//

import SwiftUI

struct WorkoutHistoryPreview: View {
    
    @Environment(\.colorScheme) var colourScheme
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var profile: Profile

    var workoutHistories: FetchedResults<WorkoutHistory>
    
    @State private var showingConfirmation = false
    
    var body: some View {
        ForEach(workoutHistories.prefix(3)) { workoutHistory in
            NavigationLink(destination:
                            WorkoutHistorySummaryHome(workoutHistory: workoutHistory)) {
                ZStack {
                    
                    // Background
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colourScheme == .dark ?
                                Color(white: 0.1) :
                                Color(white: 0.9))
                    
                    VStack {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            
                            // Timestamp the workout was completed.
                            Text(formatDate(date: workoutHistory.timestamp ?? Date()))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom)
                            
                            // Chevron to indicate the row can be pressed.
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.secondary)
                                .padding([.bottom, .trailing])
                        }
                    }
            
                    // Workout details
                    HStack {
                        WorkoutIconGrid(exercises: workoutHistory.workout?.exerciseArray ?? [],
                                        size: 80)
                        
                        VStack(alignment: .leading) {

                            // Workout name.
                            Text(workoutHistory.workout?.name ?? "")
                                .foregroundColor(.primary)
                                .bold()
                            
                            // Estimate of the type of workout based on the exercises it includes.
                            Text(workoutHistory.workout?.category ?? "" == "All" ? "All Body" :
                                 workoutHistory.workout?.category ?? "")
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            // The time taken to complete the workout.
                            Text(formatSeconds(seconds: Int(workoutHistory.time)))
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            // Display which device the workout was run on.
                            if (workoutHistory.avgHeartRate > 0) {
                                Image(systemName: "applewatch")
                                    .foregroundColor(.primary)
                            } else {
                                Image(systemName: "iphone")
                                    .foregroundColor(.primary)
                            }
                        }
                        Spacer()
                    }
                    .padding([.leading, .trailing], 25)
                }

                // Hold on a workout history row to access this menu.
                .contextMenu {

                    // Button to delete a workout history.
                    Button(role: .destructive) {
                        showingConfirmation.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }

                // Confirmation box before deleting a workout history.
                .confirmationDialog("Are you sure?",
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
                .frame(maxWidth: .infinity, minHeight: 110)
                .padding([.leading, .trailing])
            }
        }
    }

}
