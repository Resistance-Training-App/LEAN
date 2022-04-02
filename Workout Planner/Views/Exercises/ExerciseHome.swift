//
//  CategoryHome.swift
//  Workout Planner
//
//  The main page listing the exercises available in the app with filters.
//

import SwiftUI
import CoreData

struct ExerciseHome: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>
    
    @EnvironmentObject var profile: Profile

    @State var showFavouritesOnly = false
    @State var bodyPartFilter: Category = .all
    @State var equipmentFilter: Equipment = .all
    @State var createdByFilter: CreatedBy = .all
    @State var showFilters: Bool = false
    @State var showListView: Bool = false
    @State var sortBy: SortType = .oldToNew
    @State var showNewExercise: Bool = false
    @State var newExerciseData = Exercise.Template()
    @State var type: ExerciseEdit.exerciseType = ExerciseEdit.exerciseType.reps
    @State var isValidExercise = true

    var body: some View {
        NavigationView {
            Section {
                if (showListView) {
                    
                    // List of exercises.
                    ExerciseList(allExercises: Array(exercises),
                                 showFavouritesOnly: $showFavouritesOnly,
                                 bodyPartFilter: $bodyPartFilter,
                                 equipmentFilter: $equipmentFilter,
                                 createdByFilter: $createdByFilter,
                                 showFilters: $showFilters,
                                 sortBy: $sortBy)
                } else {
                    
                    // Exercises displayed in body part categories.
                    ExerciseCategory(exercises: Array(exercises))
                }
            }
            .navigationTitle("Exercises")
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: { showListView.toggle() }) {

                        // Switch icon based on current exercise view
                        Image(systemName: showListView ? "circle.grid.2x2" : "list.bullet")
                            .resizable()
                            .frame(width: showListView ? 20 : 25, height: 20, alignment: .center)
                        }
                        // Display the sort picker if the list view is displaying.
                        if (showListView) {
                            ExerciseSorter(sortBy: $sortBy)
                        }
                    },
                trailing:
                    HStack(spacing: 20) {
                        
                        // Display the exercise filter button if the list view is displaying.
                        if (showListView) {
                            Button(action: { showFilters.toggle() }) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        
                        Button(action: { showNewExercise = true }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    }
            )
        }

        // A sheet displayed when a user is filtering the list of exercises.
        .sheet(isPresented: $showFilters) {
            NavigationView {
                ExerciseFilters(showFavouritesOnly: $showFavouritesOnly,
                                bodyPartFilter: $bodyPartFilter,
                                equipmentFilter: $equipmentFilter,
                                createdByFilter: $createdByFilter,
                                showFilters: $showFilters)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            showFilters.toggle()
                        }
                    )
            }
            .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                        profile.theme == Themes.light.id ? .light : .dark)
        }

        // A sheet displayed when a user is creating a new exercise.
        .sheet(isPresented: $showNewExercise) {
            NavigationView {
                ExerciseEdit(exerciseData: $newExerciseData,
                             type: $type,
                             isValidExercise: $isValidExercise)
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showNewExercise = false
                        },
                        trailing: Button("Add") {
                            let newExercise = Exercise(context: viewContext)
                            newExercise.id = UUID()
                            newExercise.order = Int64(exercises.count)
                            newExercise.name = newExerciseData.name
                            newExercise.repTime = newExerciseData.repTime
                            newExercise.desc = newExerciseData.desc
                            newExercise.tutorial = newExerciseData.tutorial
                            newExercise.isFavourite = newExerciseData.isFavourite
                            newExercise.isHold = type == .hold ? true : false
                            newExercise.weight = NSSet.init()
                            newExercise.reps = NSSet.init()
                            newExercise.picture = UIImage(data: newExerciseData.picture)?.pngData()
                                                  ?? UIImage().pngData()
                            newExercise.isLearnt = false
                            newExercise.userCreated = true
                            newExercise.category = newExerciseData.category
                            newExercise.equipment = newExerciseData.equipment

                            do { try viewContext.save() } catch {
                                print(error.localizedDescription)
                            }
                            PersistenceController.shared.save()
                            newExerciseData = Exercise.Template()
                            showNewExercise.toggle()
                        }
                        .disabled(!isValidExercise)
                    )
            }
            .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                        profile.theme == Themes.light.id ? .light : .dark)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
