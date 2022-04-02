//
//  ToggleFavourite.swift
//  ToggleFavourite
//
//  Button to toggle the favourite status of that exercise.
//

import SwiftUI

struct ToggleExerciseFavourite: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isFavourite: Bool
        
    var exercise: Exercise
    var exercises: [Exercise]
    
    var body: some View {
        Button {
            guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exercise.id }) else {
                fatalError("Can't find exercise in array")
            }
            exercises[exerciseIndex].isFavourite.toggle()
            isFavourite.toggle()
            
            do { try viewContext.save() } catch {
                print(error.localizedDescription)
            }
            PersistenceController.shared.save()
        } label: {
            if (isFavourite) {
                Label("Remove from Favourites",
                      systemImage: "star.fill")
            } else {
                Label("Add to Favourites",
                      systemImage: "star")
            }
        }
    }
}
