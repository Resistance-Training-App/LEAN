//
//  WorkoutSorter.swift
//  WorkoutSorter
//
//  A picker used to change the order in which the workouts appear.
//

import SwiftUI

struct WorkoutSorter: View {
    
    @Binding var sortBy: SortType
    
    var body: some View {

        Picker("Sort Workouts", selection: $sortBy) {
            Text("Oldest First")
                .tag(SortType.oldToNew)
            Text("Newest First")
                .tag(SortType.newToOld)
            Text("Time Ascending")
                .tag(SortType.timeAscending)
            Text("Time Descending")
                .tag(SortType.timeDescending)
            Text("Sets Ascending")
                .tag(SortType.setsAscending)
            Text("Sets Descending")
                .tag(SortType.setsDescending)
            Text("A to Z")
                .tag(SortType.aToZ)
        }
    }
}
