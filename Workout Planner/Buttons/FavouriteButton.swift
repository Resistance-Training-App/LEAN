//
//  FavouriteButton.swift
//  Workout Planner
//  
//  Button used to favourite a workout or exercise.
//

import SwiftUI

struct FavouriteButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isSet: Bool

    var body: some View {
        Button {
            isSet.toggle()
            do { try viewContext.save() } catch {
                print(error.localizedDescription)
            }
            PersistenceController.shared.save()
        } label: {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}
