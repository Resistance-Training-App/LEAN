//
//  WorkoutDetail.swift
//  Workout Planner
//
//  A page that displays all workout details when a user clicks on a specific workout.
//

import SwiftUI
import CoreData

struct WorkoutDetail: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>
    
    @EnvironmentObject var workout: WorkoutManager

    @ObservedObject var myWorkout: Workout
    
    @State private var workoutData: Workout.Template = Workout.Template()
    @State private var deletedExercises: [Exercise] = []
    @State private var showEdit = false
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
    
            // Displays details such as the name, estimated time, number of sets and a favourite
            // button for the workout.
            VStack(alignment: .leading) {
                HStack {
                    Text(myWorkout.name ?? "")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    FavouriteButton(isSet: $myWorkout.isFavourite)
                    Spacer()
                }

                // Length of warm-up and number of sets in the workout.
                HStack {
                    Text(myWorkout.category ?? "" == "All" ? "All Body" : myWorkout.category ?? "")
                    Spacer()
                    if (myWorkout.warmUp == StretchLength.none.id) {
                        Text("No warm-up")
                    } else {
                        Text("\(myWorkout.warmUp ?? "N/A") warm-up")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                // Length of cooldown and estimated amount of time the workout will take.
                HStack {
                    Text("Estimated time: \(formatSeconds(seconds: Int(myWorkout.time)))")
                    Spacer()
                    if (myWorkout.coolDown == StretchLength.none.id) {
                        Text("No cool-down")
                    } else {
                        Text("\(myWorkout.coolDown ?? "N/A") cool-down")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                // Button to start the workout on the iPhone.
                Button {
                    workout.myWorkout = myWorkout
                    workout.startWorkout()
                } label: {
                    HStack {
                        Image(systemName: "play.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Start")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(.borderedProminent)
                .disabled((myWorkout.exercises?.count ?? 0) < 1)
                .opacity((myWorkout.exercises?.count ?? 0) < 1 ? 0.5 : 1)

                Divider()
                
                // A list of exercises in the workout.
                ForEach(myWorkout.exerciseArray, id: \.self) { exercise in
                    WorkoutExerciseRow(exercise: exercise)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(myWorkout.name ?? "")
        .navigationBarItems(
            trailing:
                HStack(spacing: 20) {

                    // Button to start editing the workout.
                    Button {
                        workoutData = myWorkout.template
                        showEdit = true
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }

                    // Button to begin the process of deleting the workout.
                    Button {
                        showingConfirmation.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
        )

        // Confirmation box before deleting the workout.
        .confirmationDialog("Are you sure?",
                            isPresented: $showingConfirmation,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                withAnimation {
                    viewContext.delete(myWorkout)
                    do { try viewContext.save() } catch {
                        print(error.localizedDescription)
                    }
                    PersistenceController.shared.save()
                }
            } label: {
                Text("Delete \(myWorkout.name ?? "Workout")")
            }
        }

        // New sheet that allows the user to edit the workout when the edit button is pressed.
        .fullScreenCover(isPresented: $showEdit) {
            NavigationView {
                WorkoutEdit(workoutData: $workoutData, deletedExercises: $deletedExercises)
                    .navigationBarItems( trailing: Button("Done") {
                        editWorkout(showEdit: &showEdit,
                                    workoutData: &workoutData,
                                    myWorkout: myWorkout,
                                    deletedExercises: &deletedExercises,
                                    viewContext: viewContext)
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitle(myWorkout.name ?? "")
            }
        }
    }
}
