//
//  ExerciseSorter.swift
//  ExerciseSorter
//
//  A picker to select how the exercises are sorted.
//

import SwiftUI

struct ExerciseSorter: View {
    
    @Binding var sortBy: SortType
    
    var body: some View {
        HStack {
            Picker("Exercise", selection: $sortBy) {
                Text("Oldest First")
                    .tag(SortType.oldToNew)
                Text("Newest First")
                    .tag(SortType.newToOld)
                Text("A to Z")
                    .tag(SortType.aToZ)

                }
        }
        .pickerStyle(MenuPickerStyle())
    }
}
