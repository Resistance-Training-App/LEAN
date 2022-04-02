//
//  ExerciseFilters.swift
//  Workout Planner
//
//  The three filters found at the bottom of the screen on the exercise list.
//

import SwiftUI

struct ExerciseFilters: View {
    
    @Environment(\.colorScheme) var colourScheme
    
    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var equipmentFilter: Equipment
    @Binding var createdByFilter: CreatedBy
    @Binding var showFilters: Bool

    var body: some View {
        List {

            VStack {
                Text("Body part")
                    .font(.headline)
                
                // Picker to select exercises that only work a particular part of the body.
                Picker("Body part", selection: $bodyPartFilter) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.id)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])

            VStack {
                Text("Equipment")
                    .font(.headline)
                
                // Picker to select exercises that only require a particular piece of equipment.
                Picker("Equipment", selection: $equipmentFilter) {
                    ForEach(Equipment.allCases, id: \.self) { equipment in
                        Text(equipment.id)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])
            
            VStack {
                Text("Created by")
                    .font(.headline)
                
                // Picker to select exercises that only require a particular piece of equipment.
                Picker("Created", selection: $createdByFilter) {
                    ForEach(CreatedBy.allCases, id: \.self) { createdBy in
                        Text(createdBy.id)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])
            
            // Toggle to only display exercises that are in the user's favourites.
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
