//
//  WorkoutCategory.swift
//  Workout Planner
//
//  Displays each workout in their respective categories.
//

import SwiftUI
import CoreData

struct WorkoutCategory: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    var workouts: FetchedResults<Workout>

    var body: some View {
        ScrollView {
            
            // Favourite workouts.
            if (workouts.filter{ ((!$0.isCopy) && ($0.isFavourite)) }.count > 0) {
                WorkoutCategoryRow(workouts: workouts
                                             .filter{ ((!$0.isCopy) && ($0.isFavourite)) }
                                             .sorted(by: { $0.name ?? "" < $1.name ?? ""}),
                                   categoryName: "Favourites")
            }
            
            // Workouts separated by category.
            ForEach(Category.allCases, id: \.self) { category in
                if (workouts.filter{ ((!$0.isCopy) &&
                ($0.category == category.id) && !($0.isFavourite)) }.count > 0) {
                    WorkoutCategoryRow(workouts: workouts
                                                 .filter{ ((!$0.isCopy) &&
                                                           ($0.category == category.id)
                                                           && !($0.isFavourite)) }
                                                 .sorted(by: { $0.name ?? "" < $1.name ?? ""}),
                                       categoryName: category == .all ? "All Body" : category.id)
                }
            }
        }
    }
}
