//
//  ExerciseList.swift
//  Workout Planner
//
//  The list of exercises that can be tapped on to display more information about that exercise.
//

import SwiftUI

struct ExerciseList: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var allExercises: [Exercise]
    
    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var equipmentFilter: Equipment
    @Binding var createdByFilter: CreatedBy
    @Binding var showFilters: Bool
    @Binding var sortBy: SortType

    @State private var searchText = ""

    // The list of exercises to be displayed based on the filters selected.
    var filteredExercises: [Exercise] {

        var exercises: [Exercise]

        exercises = allExercises.filter { exercise in
            ((!showFavouritesOnly || exercise.isFavourite) &&
             (bodyPartFilter == .all || bodyPartFilter.id == exercise.category) &&
             (equipmentFilter == .all || equipmentFilter.id == exercise.equipment) &&
             (createdByFilter == .all || ((createdByFilter.id == CreatedBy.userCreated.id) &&
             (exercise.userCreated)) || ((createdByFilter.id == CreatedBy.default.id) &&
                                         (!exercise.userCreated))) && (exercise.reps?.count == 0))
        }

        switch(sortBy) {
            case SortType.oldToNew:
                exercises = exercises.sorted(by: { $0.order < $1.order })
            case SortType.newToOld:
                exercises = exercises.sorted(by: { $0.order > $1.order })
            case SortType.aToZ:
                exercises = exercises.sorted(by: { $0.name ?? "" < $1.name ?? "" })
            default:
                ()
        }
        
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { ($0.name ?? "").contains(searchText) }
        }
    }

    var body: some View {
        List {
            ForEach(filteredExercises) { exercise in

                // Navigation link to view the exercise in detail.
                NavigationLink(destination: ExerciseDetail(exercise: exercise)
                    .onAppear { showFilters = false }) {
                         ExerciseListRow(exercise: exercise)
                    }
                
                    // Allows the user to favourite or un-favourite an exercise.
                    .swipeActions(edge: .leading) {
                        Button {
                            toggleFavourite(exercise: exercise)
                        } label: {
                            Label("Favorite", systemImage: exercise.isFavourite ? "star" : "star.fill")
                        }
                        .tint(.yellow)
                    }
                     
                    // Only allow the user to delete exercise they have created.
                    .if (exercise.userCreated) {
                        $0.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                removeExercise(exercise: exercise)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
            }
        }
        .searchable(text: $searchText)
    }
    
    // Function to delete a user created exercise.
    func removeExercise(exercise: Exercise) {
        let index = allExercises.firstIndex(of: exercise)!
        
        for exercise in allExercises {
            if (exercise.order > index) {
                exercise.order -= 1
            }
        }
        
        viewContext.delete(exercise)
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
    
    // Function to toggle the favourite status of the exercise.
    func toggleFavourite(exercise: Exercise) {
        guard let exerciseIndex = allExercises.firstIndex(where: { $0.id == exercise.id }) else {
            fatalError("Can't find exercise in array")
        }
        allExercises[exerciseIndex].isFavourite.toggle()

        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
