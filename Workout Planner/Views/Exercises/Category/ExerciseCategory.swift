//
//  ExerciseCategory.swift
//  Workout Planner
//
//  Splits the exercises available into their respective categories displaying each category on a
//  different line.
//

import SwiftUI
import CoreData

struct ExerciseCategory: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var exercises: [Exercise]

    var body: some View {
        ScrollView {
            ForEach(Category.allCases, id: \.self) { category in
                ExerciseCategoryRow(exercises: exercises
                                               .filter{ ($0.reps?.count == 0 && $0.category == category.id)}
                                               .sorted(by: { $0.name ?? "" < $1.name ?? ""}),
                                    categoryName: category == .all ? "All Body" : category.id)
            }
        }
    }
}
