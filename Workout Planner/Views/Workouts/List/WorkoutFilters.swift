//
//  WorkoutFilters.swift
//  Workout Planner
//
//  View to configure filters on which workouts to display in the list.
//

import SwiftUI

struct WorkoutFilters: View {
    
    @Environment(\.colorScheme) var colourScheme
    
    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var lengthFilter: Length
    @Binding var showFilters: Bool
    
    var body: some View {
        List {

            // Picker to select workouts that mostly work a particular part of the body.
            VStack {
                Text("Body part")
                    .font(.headline)
                
                Picker("Body part", selection: $bodyPartFilter) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])

            // Picker to select length based on the estimated time.
            VStack {
                Text("Workout Time")
                    .font(.headline)

                Picker("Workout Length", selection: $lengthFilter) {
                    ForEach(Length.allCases, id: \.self) { length in
                        if (length == Length.all) {
                            Text("All")
                        } else if (length == Length.short) {
                            Text("<20")
                        } else if (length == Length.medium) {
                            Text("20 to 40")
                        } else if (length == Length.long) {
                            Text(">40")
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])

            // Toggle to only display workouts that are in the user's favourites.
            HStack {
                Spacer()
                VStack {
                    Text("Favourites Only")
                        .font(.headline)

                    HStack {
                        if showFavouritesOnly {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                        }
                        Toggle(isOn: $showFavouritesOnly){}
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .labelsHidden()
                    }
                }
                Spacer()
            }
            .padding()
        }
        .listStyle(GroupedListStyle())
    }
}
