//
//  WorkoutHome.swift
//  WorkoutHome
//
//  Main Apple Watch view, displays a list of workouts with sheets that appear to sort or filter the
//  list of workouts.
//

import SwiftUI

struct WorkoutHome: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profile: Profile
    
    @State var showSorter: Bool = false
    @State var sortBy: SortType = .oldToNew
    
    @State var showFilters: Bool = false
    @State var showFavouritesOnly: Bool = false
    @State var bodyPartFilter: Category = .all
    @State var lengthFilter: Length = .all
    
    var body: some View {

        // List of workouts.
        WorkoutList(showSorter: $showSorter,
                    sortBy: $sortBy,
                    showFilters: $showFilters,
                    showFavouritesOnly: $showFavouritesOnly,
                    bodyPartFilter: $bodyPartFilter,
                    lengthFilter: $lengthFilter).environmentObject(profile)
        
            // A sheet displayed when a user sorting the list of workouts.
            .sheet(isPresented: $showSorter) {
                NavigationView {
                    WorkoutSorter(sortBy: $sortBy)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showSorter = false }
                            }
                        })
                }
            }
        
            // A sheet displayed when a user filtering the list of workouts.
            .sheet(isPresented: $showFilters) {
                NavigationView {
                    WorkoutFilters(showFilters: $showFilters,
                                   showFavouritesOnly: $showFavouritesOnly,
                                   bodyPartFilter: $bodyPartFilter,
                                   lengthFilter: $lengthFilter)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showFilters = false }
                            }
                        })
                }
            }
    }
}
