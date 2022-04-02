//
//  ExerciseDetail.swift
//  Workout Planner
//
//  The page to display details about a particular exercise.
//

import SwiftUI

struct ExerciseDetail: View {

    @Environment(\.colorScheme) var colourScheme
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var exercise: Exercise
    
    @State var type: ExerciseEdit.exerciseType = ExerciseEdit.exerciseType.reps
    @State private var exerciseData: Exercise.Template = Exercise.Template()
    @State private var showEdit = false
    @State private var showingConfirmation = false
    @State var isValidExercise = true

    var body: some View {
            ScrollView {
                CircleImageExercise(exercise: exercise, size: 250)
                    .padding(.top, 20)

                VStack(alignment: .leading) {

                    // This section includes the name, category and equipment used for the exercise.
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(exercise.name ?? "")
                                    .font(.title)
                                    .foregroundColor(.primary)
                                
                                // Display a brain if the exercise had been learnt by the machine
                                // learning algorithm.
                                if exercise.isLearnt {
                                    Image(systemName: "brain")
                                        .foregroundColor(.pink)
                                }
                                
                                FavouriteButton(isSet: $exercise.isFavourite)
                            }

                            HStack {
                                Text(exercise.category ?? "" == "All" ? "All Body" : exercise.category ?? "")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        Spacer()
                        if (exercise.equipment ?? "" != "All") {
                            Image(colourScheme == .dark ?
                                    "\(exercise.equipment ?? "")Light" :
                                    "\(exercise.equipment ?? "")Dark")
                                .resizable()
                                .frame(width: 100, height: 50, alignment: .center)
                        }
                    }
                    
                    // The section below includes a description of the exercise and a link to a
                    // tutorial for the exercise of YouTube.
                    if (!exercise.description.isEmpty) {
                        Divider()
                        VStack(alignment: .leading) {
                            HStack {
                                Text("About")
                                    .font(.title2)
                                Spacer()
                                if (!(exercise.tutorial?.isEmpty ?? true)) {
                                    Button {
                                        UIApplication.shared.open(URL(string: exercise.tutorial!)!)
                                    } label: {
                                        HStack {
                                            Image(systemName: "graduationcap")
                                            Text("Tutorial")
                                        }
                                    }
                                }
                            }
                            Text(exercise.desc ?? "")
                        }
                    }
                }
                Spacer()
            }
            .padding([.leading, .trailing])
            .navigationTitle(exercise.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
        
            // Only allow the user to delete or edit exercises that they created.
            .if(exercise.userCreated) {
                $0.navigationBarItems(
                    trailing:
                        HStack(spacing: 20) {
                            Button {
                                exerciseData = exercise.template
                                type = exercise.isHold ? ExerciseEdit.exerciseType.hold :
                                                         ExerciseEdit.exerciseType.reps
                                showEdit = true
                            } label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Button {
                                showingConfirmation.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                )
            }
        
            // Confirmation box before deleting the exercise.
            .confirmationDialog("Are you sure?",
                                isPresented: $showingConfirmation,
                                titleVisibility: .visible) {
                Button(role: .destructive) {
                    withAnimation {
                        viewContext.delete(exercise)
                        do { try viewContext.save() } catch {
                            print(error.localizedDescription)
                        }
                        PersistenceController.shared.save()
                    }
                } label: {
                    Text("Delete \(exercise.name ?? "Exercise")")
                }
            }

            // New sheet that allows the user to edit the exercise when the edit button is pressed.
            .fullScreenCover(isPresented: $showEdit) {
                NavigationView {
                    ExerciseEdit(exerciseData: $exerciseData,
                                 type: $type,
                                 isValidExercise: $isValidExercise)
                        .navigationBarItems(
                            leading: Button("Cancel") {
                               showEdit = false
                            },
                            trailing: Button("Done") {
                                showEdit = false
                                exerciseData.isHold = type == .hold ? true : false
                                exercise.update(from: exerciseData)
                                do { try viewContext.save() } catch {
                                    print(error.localizedDescription)
                                }
                                PersistenceController.shared.save()
                            }
                            .disabled(!isValidExercise)
                        )
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle(exercise.name ?? "")
                }
            }
        }
}
