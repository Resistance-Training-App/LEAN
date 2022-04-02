//
//  WorkoutExerciseRowEdit.swift
//  Workout Planner
//
//  A row displayed for each exercise when editing a workout.
//

import SwiftUI
import CoreData

struct WorkoutExerciseRowEdit: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colourScheme
    
    @EnvironmentObject var profile: Profile

    @ObservedObject var exercise: Exercise
    @Binding  var editMode: EditMode
    
    @State var newExerciseWeight: [Double] = []
    @State var newExerciseReps: [Double] = []

    var body: some View {
        VStack(alignment: .leading) {

            // Displays the exercise name, the area of the body it works and the equipment required.
            HStack {
                
                CircleImageExercise(exercise: exercise,
                            size: editMode == .inactive ? 50 : 30,
                            showDetails: true)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(exercise.name ?? "")
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(exercise.category ?? "" == "All" ? "All Body" : exercise.category ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if (exercise.equipment ?? "" != "All") {
                    Image(colourScheme == .dark ?
                            "\(exercise.equipment ?? "")Light" :
                            "\(exercise.equipment ?? "")Dark")
                        .resizable()
                        .frame(width: editMode == .inactive ? 100 : 60,
                               height: editMode == .inactive ? 50 : 30)
                }
                
                // Only display exercise equipment and a navigation link to edit the exercise's sets
                // if the list of exercises are not being edited and the exercise is not a hold.
                if (editMode == .inactive && !exercise.isHold) {
                    NavigationLink(destination: WorkoutExerciseRowSetsEdit(exercise: exercise,
                                                                           newExerciseWeight: $newExerciseWeight,
                                                                           newExerciseReps: $newExerciseReps))
                    {}.frame(width: 10)
                }
            }
            .padding([.top, .bottom])

            // Show slider if the exercise is a hold, otherwise display the weight and reps of the
            // exercise.
            if (exercise.isHold == true) {
                VStack {
                    Text("\(Int(exercise.repTime)) seconds")

                    Slider(value: $exercise.repTime, in: 5...100, step: 5) {
                        Text("Length")
                    }
                }
            } else {
                HStack {
                    WorkoutExerciseSetRow(exercise: exercise)
                }
            }
        }
        .onAppear {

            // Populate weight and reps arrays if they are empty.
            if (newExerciseWeight.isEmpty) {
                let weightArray = exercise.weightArray
                for weight in weightArray {
                    newExerciseWeight.append(weight.count)
                }
                
                let repArray = exercise.repsArray
                for rep in repArray {
                    newExerciseReps.append(rep.count)
                }
            // Otherwise overwrite the current exercise weight and rep values with the values of the
            // weight and reps arrays as they have been edited.
            } else {
                let weightsToAdd: NSMutableSet = NSMutableSet.init()
                var orderIndex = 0
                for weight in newExerciseWeight {
                    let newWeight = Weight(context: viewContext)
                    newWeight.count = weight
                    newWeight.order = Int64(orderIndex)
                    weightsToAdd.add(newWeight)
                    orderIndex += 1
                }
                exercise.weight = weightsToAdd.copy() as? NSSet

                let repsToAdd: NSMutableSet = NSMutableSet.init()
                orderIndex = 0
                for reps in newExerciseReps {
                    let newReps = Reps(context: viewContext)
                    newReps.count = reps
                    newReps.order = Int64(orderIndex)
                    repsToAdd.add(newReps)
                    orderIndex += 1
                }
                exercise.reps = repsToAdd.copy() as? NSSet
            }
        }
    }
}
