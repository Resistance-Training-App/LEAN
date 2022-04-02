//
//  WorkoutsHome.swift
//  Workout Planner
//
//  The main page for displaying workouts in their respective categories.
//

import SwiftUI
import CoreData

struct WorkoutHome: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profile: Profile

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.name, ascending: true)],
        animation: .default)
    var workouts: FetchedResults<Workout>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>
    
    @EnvironmentObject var workout: WorkoutManager

    @State var showFavouritesOnly = false
    @State var bodyPartFilter: Category = .all
    @State var lengthFilter: Length = .all
    @State var showFilters: Bool = false
    @State var showListView: Bool = false
    @State var sortBy: SortType = .oldToNew

    @State private var showNewWorkout = false
    @State private var showSort = false
    @State private var newWorkoutData = Workout.Template()
    @State private var deletedExercises: [Exercise] = []
    @State private var addedExercises: [Exercise] = []

    var body: some View {
    
        NavigationView {
            Section {
                if (workouts.isEmpty) {
                    
                    // Prompt user to add their first workout.
                    WorkoutAddFirstPrompt()

                } else if (showListView) {
                    
                    // List of workouts.
                    WorkoutList(allWorkouts: Array(workouts),
                                showFavouritesOnly: $showFavouritesOnly,
                                bodyPartFilter: $bodyPartFilter,
                                lengthFilter: $lengthFilter,
                                showFilters: $showFilters,
                                sortBy: $sortBy)
                } else {
                    
                    // Workouts displayed in body part categories.
                    WorkoutCategory(workouts: workouts)
                }
            }
            .navigationTitle("Workouts")
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: { showListView.toggle() }) {

                            // Switch icon based on current exercise view.
                            Image(systemName: showListView ? "square.grid.2x2" : "list.bullet")
                                .resizable()
                                .frame(width: showListView ? 20 : 25, height: 20, alignment: .center)
                        }
                        // Display the sort picker if the list view is displaying.
                        if (showListView) {
                            WorkoutSorter(sortBy: $sortBy)
                        }
                    },
                trailing:
                    HStack(spacing: 20) {
                        
                        // Display the workout filter button if the list view is displaying.
                        if (showListView) {
                            Button(action: { showFilters.toggle() }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }

                        // Button to begin creating a new workout.
                        Button(action: { showNewWorkout.toggle() }) {
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                            }
                        }
            )

            // A sheet displayed when a user is creating a new workout.
            .fullScreenCover(isPresented: $showNewWorkout) {
                NavigationView {
                    WorkoutEdit(workoutData: $newWorkoutData,
                                deletedExercises: $deletedExercises)
                        .navigationBarItems(
                            
                            // Cancel the creation of a workout.
                            leading: Button("Cancel") {
                                cancelWorkoutCreation(showNewWorkout: &showNewWorkout,
                                                      newWorkoutData: &newWorkoutData,
                                                      exercises: exercises.map { $0 },
                                                      viewContext: viewContext)
                            },
                            
                            // Add the workout.
                            trailing: Button("Done") {
                                createNewWorkout(showNewWorkout: &showNewWorkout,
                                                 newWorkoutData: &newWorkoutData,
                                                 viewContext: viewContext)
                            }
                        )
                }
            }

            // A sheet displayed when a user filtering the list of workouts.
            .sheet(isPresented: $showFilters) {
                NavigationView {
                    WorkoutFilters(showFavouritesOnly: $showFavouritesOnly,
                                   bodyPartFilter: $bodyPartFilter,
                                   lengthFilter: $lengthFilter,
                                   showFilters: $showFilters)
                        .navigationBarItems(
                            trailing: Button("Done") {
                                showFilters.toggle()
                            }
                        )
                }
            }
            
            // Pre-workout countdown view.
            .fullScreenCover(isPresented: $workout.showingCountdown) {
                WorkingOutCountdown()
            }
            
            // Stretching view.
            .fullScreenCover(isPresented: $workout.showingStretchingHome) {
                StretchingHome(stretches: workout.stretchPeriod == .warmUp
                               ? workout.warmUpArray : workout.coolDownArray)
            }

            // Working out view.
            .fullScreenCover(isPresented: $workout.showingWorkoutHome) {
                WorkingOutHome()
            }
        
            // Workout Summary view.
            .fullScreenCover(isPresented: $workout.showingSummaryView) {
                WorkoutSummaryHome()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
