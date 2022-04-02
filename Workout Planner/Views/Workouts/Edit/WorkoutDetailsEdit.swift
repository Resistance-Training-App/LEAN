//
//  WorkoutDetailsEdit.swift
//  Workout Planner
//
//  Section of the workout edit page to edit the workout's details.
//

import SwiftUI

struct WorkoutDetailsEdit: View {

    @Binding var workoutData: Workout.Template

    @State private var showingWarmUpAlert = false
    @State private var showingCoolDownAlert = false
    
    // Alert to explain what a warm-up involves and how long each length is in the picker.
    var warmUpAlert: Alert {
        Alert(title: Text("Warm-up"),
              message: Text("""
                            A warm-up will give you stretches to do before your workout starts. \
                            These stretches are based on the exercises in the workout.
                            """),
              dismissButton: .default(Text("Dismiss")))
    }
    
    // Alert to explain what a cool-down involves and how long each length is in the picker.
    var coolDownAlert: Alert {
        Alert(title: Text("Cool-down"),
              message: Text("""
                            A cool-down will give you stretches to do after your workout finishes. \
                            These stretches are based on the exercises in the workout.
                            """),
              dismissButton: .default(Text("Dismiss")))
    }

    var body: some View {
        VStack {

            // Enables you to edit the title and favourite status of the workout.
            HStack {
                TextField("Name", text: $workoutData.name)
                FavouriteButton(isSet: $workoutData.isFavourite)
                    .buttonStyle(PlainButtonStyle())
            }
            .padding([.top, .bottom])

            Divider()
            
            // Allows the user to decide if they want to include warm-up stretches before the workout.
            VStack(alignment: .leading) {
                HStack {
                    Text("Warm-up")
                        .fontWeight(.semibold)
                    
                    Button { showingWarmUpAlert.toggle() } label: {
                        Image(systemName: "info.circle")
                    }
                    .alert(isPresented: $showingWarmUpAlert, content: { warmUpAlert })
                    .buttonStyle(PlainButtonStyle())
                }
                Picker(selection: $workoutData.warmUp, label: Text("Warm-up")) {
                    Text(StretchLength.none.id).tag(StretchLength.none)
                    Text(StretchLength.short.id).tag(StretchLength.short)
                    Text(StretchLength.medium.id).tag(StretchLength.medium)
                    Text(StretchLength.long.id).tag(StretchLength.long)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])

            Divider()
            
            // Allows the user to decide if they want to include cool-down stretches after the workout.
            VStack(alignment: .leading) {
                HStack {
                    Text("Cool-down")
                        .fontWeight(.semibold)
                    
                    Button { showingCoolDownAlert.toggle() } label: {
                        Image(systemName: "info.circle")
                    }
                    .alert(isPresented: $showingCoolDownAlert, content: { coolDownAlert })
                    .buttonStyle(PlainButtonStyle())
                }
                Picker(selection: $workoutData.coolDown, label: Text("Cool-down")) {
                    Text(StretchLength.none.id).tag(StretchLength.none)
                    Text(StretchLength.short.id).tag(StretchLength.short)
                    Text(StretchLength.medium.id).tag(StretchLength.medium)
                    Text(StretchLength.long.id).tag(StretchLength.long)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding([.top, .bottom])
        }
    }
}
