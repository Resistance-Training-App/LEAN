//
//  WorkoutList.swift
//  Workout Planner
//
//  The list of workouts that can be tapped on to display more information about that workout.
//

import SwiftUI

struct WorkoutList: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var allWorkouts: [Workout]

    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var lengthFilter: Length
    @Binding var showFilters: Bool
    @Binding var sortBy: SortType

    @State private var searchText = ""
    
    // The list of workouts to be displayed based on the filters selected.
    var filteredWorkouts: [Workout] {
        
        var workouts: [Workout]
        
        workouts = allWorkouts.filter { workout in
            ((!showFavouritesOnly || workout.isFavourite) &&
             (bodyPartFilter == .all || bodyPartFilter.rawValue == workout.category) &&
             workout.isCopy == false)
        }
        
        switch(lengthFilter) {
            case Length.short:
                workouts = workouts.filter { workout in
                    (workout.time/60 < 20)
                }
            case Length.medium:
                workouts = workouts.filter { workout in
                    (workout.time/60 >= 20 && workout.time/60 < 40)
                }
            case Length.long:
                workouts = workouts.filter { workout in
                    (workout.time/60 >= 40)
                }
            default:
                ()
        }
                
        switch(sortBy) {
            case SortType.oldToNew:
                workouts = workouts.sorted(by: { $0.timeCreated ?? Date() < $1.timeCreated ?? Date() })
            case SortType.newToOld:
                workouts = workouts.sorted(by: { $0.timeCreated ?? Date() > $1.timeCreated ?? Date() })
            case SortType.timeAscending:
                workouts = workouts.sorted(by: { $0.time < $1.time })
            case SortType.timeDescending:
                workouts = workouts.sorted(by: { $0.time > $1.time })
            case SortType.setsAscending:
                workouts = workouts.sorted(by: { $0.sets < $1.sets })
            case SortType.setsDescending:
                workouts = workouts.sorted(by: { $0.sets > $1.sets })
            case SortType.aToZ:
                workouts = workouts.sorted(by: { $0.name ?? "" < $1.name ?? "" })
        }

        if searchText.isEmpty {
            return workouts
        } else {
            return workouts.filter { ($0.name ?? "").contains(searchText) }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredWorkouts) { myWorkout in
                NavigationLink(destination: WorkoutDetail(myWorkout: myWorkout)
                    .onAppear{ showFilters = false }) {
                         WorkoutListRow(workout: myWorkout)
                     }
                
                    // Allows the user to favourite or un-favourite a workout.
                    .swipeActions(edge: .leading) {
                        Button {
                            toggleFavourite(workout: myWorkout)
                        } label: {
                            Label("Favorite", systemImage: myWorkout.isFavourite ?
                                  "star" : "star.fill")
                        }
                        .tint(.yellow)
                    }
                
                    // Allows the user to delete a workout.
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            removeWorkout(workout: myWorkout)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
            }
        }
        .searchable(text: $searchText)
    }

    // Function to delete a workout.
    func removeWorkout(workout: Workout) {
        viewContext.delete(workout)
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }

    // Function to toggle the favourite status of the workout.
    func toggleFavourite(workout: Workout) {
        guard let workoutIndex = allWorkouts.firstIndex(where: { $0.id == workout.id }) else {
            fatalError("Can't find workout in array")
        }
        allWorkouts[workoutIndex].isFavourite.toggle()
        
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
