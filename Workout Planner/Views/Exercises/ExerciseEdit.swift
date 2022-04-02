//
//  ExerciseEdit.swift
//  ExerciseEdit
//
//  A page used when creating a new exercise or editing an existing one.
//

import SwiftUI

struct ExerciseEdit: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profile: Profile

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)],
        animation: .default)
    var exercises: FetchedResults<Exercise>

    @Binding var exerciseData: Exercise.Template
    @Binding var type: exerciseType
    @Binding var isValidExercise: Bool
    
    @State private var showingAlert = false
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    
    // Array of exercise names to compare the new name against.
    var exerciseNames: [String] {
        return exercises.map { ($0.name ?? "").lowercased() }
    }
    
    // Alert to explain what the rep time of an exercise is.
    var alert: Alert {
        Alert(title: Text("Rep Time"),
              message: Text("""
                            The time it takes to complete one rep of the exercise, this is used to
                            estimate the length of a workout.
                            """),
              dismissButton: .default(Text("Dismiss")))
    }
    
    enum exerciseType: String, CaseIterable, Identifiable {
        case reps, hold
        var id: String { self.rawValue }
    }

    var body: some View {
        List {
            HStack {
                Spacer()
                    
                // Exercise Picture
                Image(uiImage: UIImage(data: exerciseData.picture) ?? UIImage())
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 5))
                    .shadow(radius: 3)

                Spacer()

                VStack {
                    Spacer()
                    
                    // Edit Picture
                    Button(action: {
                        showPhotoLibrary = true
                    }) {
                        Text("Edit")
                            .font(.headline)
                            .frame(width: 80, height: 30, alignment: .center)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Delete picture and revert to the default profile picture.
                    Button(action: {
                        exerciseData.picture = Data.init()
                    }) {
                        Text("Remove")
                            .font(.headline)
                            .frame(width: 80, height: 30, alignment: .center)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(exerciseData.picture.count <= 0)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()

            // Enables you to edit the title and favourite status of the workout.
            // Checks if the exercise name already exists.
            VStack(alignment: .leading) {
                HStack {
                    TextField("Name", text: $exerciseData.name)
                        .onChange(of: exerciseData.name, perform: { name in
                            if exerciseNames.contains(name.lowercased()) {
                                isValidExercise = false
                            } else {
                                isValidExercise = true
                            }
                        })

                    FavouriteButton(isSet: $exerciseData.isFavourite)
                        .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                // Displays error message if the exercise name entered already exists as an exercise.
                if (!isValidExercise) {
                    Text("Exercise already exists")
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }
            
            // Multiline exercise description text field.
            ZStack(alignment: .leading) {
                if (exerciseData.desc.isEmpty) {
                    Text("Description")
                        .opacity(0.25)
                        .padding(.leading, 1)
                }
                TextEditor(text: $exerciseData.desc)
                Text(exerciseData.desc)
                    .opacity(0)
            }
            .padding()
            
            // Type of exercise, either an exercise with reps or a hold such as a plank.
            VStack(alignment: .leading) {
                Text("Type")

                Picker(selection: $type, label: Text("Exercise Type")) {
                    Text("Reps").tag(exerciseType.reps)
                    Text("Hold").tag(exerciseType.hold)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            // Includes a slider to change exercise rep time and an information button to explain
            // what rep time is.
            if (type == exerciseType.reps) {
                VStack(alignment: .leading) {
                    Text("Rep Time")
                    HStack {
                        Slider(value: $exerciseData.repTime, in: 1...20, step: 1) {
                            Text("Rep Time")
                        }

                        Spacer()

                        Text("\(Int(exerciseData.repTime)) second\(exerciseData.repTime > 1 ? "s" : "")")

                        Button(action: {
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                        }
                        .alert(isPresented: $showingAlert, content: { alert })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            
            // Picker to select particular part of the body the exercise works.
            Picker("Category", selection: $exerciseData.category) {
                ForEach(Category.allCases, id: \.id) { category in
                    Text(category.id)
                        .tag(category.id)
                }
            }
            .padding()
            
            // Picker to select particular part of the body the exercise works.
            Picker("Equipment", selection: $exerciseData.equipment) {
                ForEach(Equipment.allCases, id: \.id) { equipment in
                    Text(equipment.id)
                        .tag(equipment.id)
                }
            }
            .padding()
        }
        
        // Sheet displayed when the user is picking a picture for the exercise from their photo
        // library.
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
                .onDisappear {
                    exerciseData.picture = image.pngData() ?? exerciseData.picture
                }
                .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                            profile.theme == Themes.light.id ? .light : .dark)
        }
    }
}
