//
//  ToggleFavourite.swift
//  ToggleFavourite
//
//  Button to toggle the favourite status of the workout.
//

import SwiftUI

struct ToggleWorkoutFavourite: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @State var isFavourite: Bool

    var myWorkout: Workout
    var workouts: [Workout]
    
    var body: some View {
        Button {
            guard let workoutIndex = workouts.firstIndex(where: { $0.id == myWorkout.id }) else {
                fatalError("Can't find workout in array")
            }
            workouts[workoutIndex].isFavourite.toggle()
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
