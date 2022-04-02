//
//  WorkoutExerciseSets.swift
//  Workout Planner
//
//  Displays the exercise sets in a table format.
//

import SwiftUI

struct WorkoutExerciseSets: View {
    
    @EnvironmentObject var profile: Profile
    
    @Binding var newExerciseWeight: [Double]
    @Binding var newExerciseReps: [Double]
    @Binding var setIndex: Int

    var body: some View {
        VStack {
            List {
                GeometryReader { geometry in
                    HStack {
                        
                        // Add a new set to the current exercise based on the current value of the weight
                        // and reps pickers.
                        Button {
                            newExerciseWeight.append(newExerciseWeight[setIndex])
                            newExerciseReps.append(newExerciseReps[setIndex])
                            setIndex = newExerciseWeight.count-1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 21, height: 21)
                                .accentColor(Color.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.leading, 2)
                        // Does not align properly for all screens, needs fixing.
                        //.padding(.trailing, UIScreen.main.bounds.size.width / 30)
                        .padding(.trailing, geometry.size.width / 24)
                            
                        // Table headers.
                        Text("Set")
                            .frame(width: 40)
                            .font(.headline)

                        Divider()

                        Text("Weight")
                            .frame(width: 90)
                            .font(.headline)

                        Divider()

                        Text("Reps")
                            .frame(width: 40)
                            .font(.headline)
                    }
                }
                ForEach(0...newExerciseWeight.count-1, id: \.self) { currentSet in
                    HStack {

                        // Exercise set number.
                        Text(String(currentSet+1))
                            .if(currentSet == setIndex) {
                                $0.font(.system(size: 18).weight(.black))
                            }
                            .frame(width: 40)

                        Divider()
                        
                        // Weight of current set.
                        Text("\(String(format: newExerciseWeight[currentSet].truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", newExerciseWeight[currentSet])) \(profile.weightUnit ?? "")")
                            .if(currentSet == setIndex) {
                                $0.font(.system(size: 18).weight(.black))
                            }
                            .frame(width: 90)

                        Divider()
                        
                        // Rep count of current set.
                        Text(String(format: "%.0f", newExerciseReps[currentSet]))
                            .if(currentSet == setIndex) {
                                $0.font(.system(size: 18).weight(.black))
                            }
                            .frame(width: 40)
                    }
                    .onTapGesture {
                        setIndex = currentSet
                    }
                }
                // Delete a set from an exercise.
                .onDelete(perform: onDelete)

                // Move a set to a different point in the exercise.
                .onMove(perform: onMove)

                // Ensures an exercise will have at least one set.
                .deleteDisabled(newExerciseWeight.count == 1)
            }
            .environment(\.editMode, .constant(EditMode.active))
        }
    }

    // Function to delete a set from the exercise.
    private func onDelete(offsets: IndexSet) {
        if (offsets.first! < setIndex || newExerciseWeight.count-1 == setIndex) {
            setIndex -= 1
        }
        newExerciseWeight.remove(atOffsets: offsets)
        newExerciseReps.remove(atOffsets: offsets)
    }

    // Function to change the order of sets for this exercise.
    private func onMove(source: IndexSet, destination: Int) {
        let newDestination: Int
        
        if (source.first! < destination) {
            newDestination = destination - 1
        } else {
            newDestination = destination
        }
        newExerciseWeight.move(fromOffsets: source, toOffset: destination)
        newExerciseReps.move(fromOffsets: source, toOffset: destination)
        
        if (source.first! == setIndex) {
            setIndex = newDestination
        } else if (newDestination == setIndex) {
            setIndex = source.first!
        }
    }
}
