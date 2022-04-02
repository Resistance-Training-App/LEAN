//
//  WorkoutList.swift
//  WorkoutList
//
//  List of workouts created by the user.
//

import SwiftUI

struct WorkoutList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var profile: Profile
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.name, ascending: true)],
        animation: .default)
    var allWorkouts: FetchedResults<Workout>
    
    // Only display created workouts, not copies that are made when a workout is complete.
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

        return workouts
    }
    
    @Binding var showSorter: Bool
    @Binding var sortBy: SortType
    @Binding var showFilters: Bool
    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var lengthFilter: Length
        
    var body: some View {
        List {

            // Button to start an open workout.
            JustWorkoutButton()
            
            // Display a prompt to create workouts on the phone application.
            if (allWorkouts.isEmpty) {
                Text("Create a workout on your iPhone for it to appear here.")
                    .multilineTextAlignment(.center)
            }
        
            // List of workouts.
            ForEach(filteredWorkouts, id: \.self) { workout in
                NavigationLink(destination: WorkoutDetail(myWorkout: workout).environmentObject(profile)) {
                    WorkoutListRow(myWorkout: workout)
                }
            }
        }
        .navigationTitle("Workouts")
        
        // Buttons above the workout list to sort and/or filter the workouts.
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                HStack {
                    Button { showSorter = true } label: {
                        VStack {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .font(.system(size: 40))
                            Text("Sort")
                        }
                    }
                    .frame(width: WKInterfaceDevice.current().screenBounds.width/2-5,
                           height: WKInterfaceDevice.current().screenBounds.width/2-5)

                    Button { showFilters = true } label: {
                        VStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 40))

                            Text("Filter")
                        }
                    }
                    .frame(width: WKInterfaceDevice.current().screenBounds.width/2-5,
                           height: WKInterfaceDevice.current().screenBounds.width/2-5)
                }
            }
        }
        .onAppear {
            workout.requestAuthorization()
        }
    }
}
