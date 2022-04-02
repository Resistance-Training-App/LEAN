//
//  WorkoutFilter.swift
//  WorkoutFilter
//
//  View to configure filters on which workouts to display in the list.
//

import SwiftUI

struct WorkoutFilters: View {
    
    @Binding var showFilters: Bool
    @Binding var showFavouritesOnly: Bool
    @Binding var bodyPartFilter: Category
    @Binding var lengthFilter: Length
    
    var body: some View {
        List {

            // Picker to select workouts that mostly work a particular part of the body.
            Picker("Body Part", selection: $bodyPartFilter) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue)
                }
            }

            // Picker to select length based on the estimated time.
            Picker("Workout Time", selection: $lengthFilter) {
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

            // Toggle to only display workouts that are in the user's favourites.
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Favourites Only")
                        .lineLimit(1)
                    
                    Toggle(isOn: $showFavouritesOnly){}
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .labelsHidden()
                    
                }

                Spacer()

                if showFavouritesOnly {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: WKInterfaceDevice.current().screenBounds.height > 197 ?
                                      32 : 22))
                } else {
                    Image(systemName: "star")
                        .font(.system(size: WKInterfaceDevice.current().screenBounds.height > 197 ?
                                      32 : 22))
                }
            }
            .padding(.bottom, 5)
        }
    }
}
