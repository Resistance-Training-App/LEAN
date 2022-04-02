//
//  WorkoutAddExercise.swift
//  Workout Planner
//
//  Page displayed when the user is adding a new exercise to a workout.
//

import SwiftUI
import CoreData

struct WorkoutAddExercise: View {
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var profile: Profile

    @Binding var workoutData: Workout.Template
    var allExercises: FetchedResults<Exercise>
    
    @State var showFavouritesOnly = false
    @State var bodyPartFilter: Category = .all
    @State var equipmentFilter: Equipment = .all
    @State var createdByFilter: CreatedBy = .all
    @State var showFilters: Bool = false
    @State var sortBy: SortType = .oldToNew

    @State var newExerciseName: String = ""
    @State var newExerciseWeight: [Double] = [0]
    @State var newExerciseReps: [Double] = [1]
    @State var newExerciseRepTime: Double = 5
    @State var setIndex: Int = 0
    @State var showConfirmation: Bool = false
    
    // The list of exercises to be displayed based on the filters selected.
    var filteredExercises: [Exercise] {

        var exercises: [Exercise]

        exercises = allExercises.filter { exercise in
            ((!showFavouritesOnly || exercise.isFavourite) &&
             (bodyPartFilter == .all || bodyPartFilter.id == exercise.category) &&
             (equipmentFilter == .all ||  equipmentFilter.id == exercise.equipment) &&
             (createdByFilter == .all ||  ((createdByFilter.id == CreatedBy.userCreated.id) &&
             (exercise.userCreated)) || ((createdByFilter.id == CreatedBy.default.id) &&
                                         (!exercise.userCreated))) && (exercise.reps?.count == 0))
        }
        
        switch(sortBy) {
            case SortType.oldToNew:
                exercises = exercises.sorted(by: { $0.order < $1.order })
            case SortType.newToOld:
                exercises = exercises.sorted(by: { $0.order > $1.order })
            case SortType.aToZ:
                exercises = exercises.sorted(by: { $0.name ?? "" < $1.name ?? "" })
            default:
                ()
        }

        return exercises
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Form {

                // A picker to select the exercise to add.
                Picker("Exercise ", selection: $newExerciseName) {
                    ForEach(loadExerciseNames()!, id: \.self) { exercise in
                        WorkoutAddExerciseRow(exercise:
                            filteredExercises.first(where: {$0.name == exercise})!)
                    }
                }
                .padding([.top, .bottom], 5)

                // Only show exercise configuration once an exercise has been selected.
                if (!newExerciseName.isEmpty) {

                    // Show a slider for rep time if the exercise is a hold.
                    if (((filteredExercises.first(where: { $0.name == newExerciseName }))?.isHold) == true) {
                        VStack {
                            Text("\(Int(newExerciseRepTime)) seconds")

                            Slider(value: $newExerciseRepTime, in: 5...100, step: 5) {
                                Text("Length")
                            }
                        }
                        .padding()

                    // Three wheel pickers to select the set, weight and number of reps for the
                    // exercise that is being added to the workout.
                    } else {
                        HStack {
                            VStack(spacing: 0) {
                                Text("Set")
                                    .font(.headline)

                                CustomIntPicker(selection: $setIndex,
                                                list: Array(0...newExerciseWeight.count-1),
                                                unit: "")
                                    .id(setIndex)
                            }
                            VStack(spacing: 0) {
                                Text("Weight")
                                    .font(.headline)

                                CustomPicker(selection: $newExerciseWeight[setIndex],
                                             list: Array(stride(from: 0, through: 999, by: 0.5)),
                                             unit: profile.weightUnit ?? "")
                                    .id(setIndex)
                            }
                            VStack(spacing: 0) {
                                Text("Reps")
                                    .font(.headline)

                                CustomPicker(selection: $newExerciseReps[setIndex],
                                             list: Array(stride(from: 1, through: 999, by: 1)),
                                             unit: "")
                                    .id(setIndex)
                            }
                        }
                    }
                }
            }

            if (!newExerciseName.isEmpty &&
            ((filteredExercises.first(where: { $0.name == newExerciseName })?.isHold) == false)) {
                WorkoutExerciseSets(newExerciseWeight: $newExerciseWeight,
                                    newExerciseReps: $newExerciseReps,
                                    setIndex: $setIndex)
            }
        }
        // Buttons to sort and filter to exercises displayed.
        .navigationBarItems(trailing:
            HStack {
                ExerciseSorter(sortBy: $sortBy)
            
                Button(action: { showFilters.toggle() }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        )

        // A sheet displayed when a user filtering the list of exercises.
        .sheet(isPresented: $showFilters) {
            NavigationView {
                ExerciseFilters(showFavouritesOnly: $showFavouritesOnly,
                                bodyPartFilter: $bodyPartFilter,
                                equipmentFilter: $equipmentFilter,
                                createdByFilter: $createdByFilter,
                                showFilters: $showFilters)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            showFilters.toggle()
                        }
                    )
            }
            .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                        profile.theme == Themes.light.id ? .light : .dark)
        }
        
        // A box displayed over the interface notifying the user the exercise was added to the
        // workout.
        .overlay(
            VStack(alignment: .center) {
                if (showConfirmation) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 200, height: 100)
                            .overlay(
                                Text("Exercise Added")
                                    .font(.largeTitle)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .multilineTextAlignment(.center)
                            )
                }
            }
        )
        
        // Buttons to add the exercise to either the start or end of the workout.
        .safeAreaInset(edge: .bottom) {
            ZStack {
                Rectangle()
                    .fill(colorScheme == .light ? Color.init(red: 0.95, green: 0.95, blue: 0.97)
                                                : Color.black)
                    .frame(width: UIScreen.main.bounds.size.width,
                           height: UIScreen.main.bounds.size.height / 8)
                HStack {
                    Spacer()
                    WorkoutAddExerciseButton(workoutData: $workoutData,
                                             showConfirmation: $showConfirmation,
                                             newExerciseName: newExerciseName,
                                             newExerciseWeight: newExerciseWeight,
                                             newExerciseReps: newExerciseReps,
                                             newExerciseRepTime: newExerciseRepTime,
                                             addToStart: true)
                    Spacer()
                    WorkoutAddExerciseButton(workoutData: $workoutData,
                                             showConfirmation: $showConfirmation,
                                             newExerciseName: newExerciseName,
                                             newExerciseWeight: newExerciseWeight,
                                             newExerciseReps: newExerciseReps,
                                             newExerciseRepTime: newExerciseRepTime,
                                             addToStart: false)
                    Spacer()
                }
            }
        }
        .padding(.bottom, -35)
        .onChange(of: newExerciseName) { _ in
            newExerciseWeight = [0]
            newExerciseReps = [1]
            newExerciseRepTime = 5
            setIndex = 0
        }
    }
    
    // Returns an array of exercise names.
    func loadExerciseNames() -> [String]? {
        var exerciseNames: [String] = []

        for exercise in filteredExercises {
            if (exercise.weight?.count == 0 && exercise.reps?.count == 0) {
                exerciseNames.append(exercise.name ?? "")
            }
        }

        return exerciseNames
    }
}
