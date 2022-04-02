//
//  WorkoutHistoryExerciseDetails.swift
//  Workout Planner
//
//  Displays a more detailed breakdown of the user's form and other metrics during a set.
//

import SwiftUI

struct WorkoutHistoryExerciseDetails: View {
    
    let exercise: Exercise
    var isJustWorkout: Bool?
    
    var colours: [Color] = [.green, .blue, .red, .orange, .yellow]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // A colour coded legend displaying which colour is assigned to which form type.
                ExerciseFormKey(formTypes: findUniqueFormTypes(metrics: exercise.metricsArray),
                                colours: colours)
                
                ForEach(0..<(exercise.metricsArray.count), id: \.self) { i in
                    HStack {
                        Text("Set \(i+1)")
                            .font(.title)
                        Spacer()
                    }
                    
                    // Displays a timeline of exercise form during the workout.
                    ExerciseFormTimeline(exercise: exercise,
                                         index: i,
                                         formTypes: findUniqueFormTypes(metrics: exercise.metricsArray),
                                         colours: colours)
                        .padding(.bottom)
                    
                    // Box of statistics displayed at the top of the workout summary view.
                    WorkoutHistoryExerciseSummaryBox(exercise: exercise,
                                                     index: i,
                                                     isJustWorkout: isJustWorkout ?? false)
                    
                    if (i != exercise.metricsArray.count-1) {
                        Divider()
                            .padding([.bottom])
                    }
                }
            }
            .padding()
        }
        .navigationTitle(exercise.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
