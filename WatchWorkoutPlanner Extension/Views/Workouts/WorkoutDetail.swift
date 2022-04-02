//
//  WorkoutDetail.swift
//  WorkoutDetail
//
//  Displays details on the selected workout and a button to start the workout.
//

import SwiftUI
import CoreData

struct WorkoutDetail: View {
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile
    
    @ObservedObject var myWorkout: Workout

    var body: some View {
        ScrollView {

            // Displays details on the selected workout.
            VStack(alignment: .leading) {
                HStack {
                    Group {
                        Spacer()
                        
                        // Type of workout estimated from the exercises it contains.
                        Text(myWorkout.category ?? "" == "All" ? "All Body" : myWorkout.category ?? "")
                            .frame(width: 75)
                        Spacer()
                    }
                    Divider()
                    Group {
                        Spacer()
                        
                        // Estimated length of time the workout will take.
                        Text(formatSeconds(seconds: Int(myWorkout.time)))
                            .frame(width: 75)
                        Spacer()
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

                // Button to start the workout.
                Button(action: {
                    workout.justWorkout = false
                    motion.justWorkout = false
                    workout.startWorkout()
                }) {
                    HStack {
                        Image(systemName: "play.circle")
                            .font(Font.body.bold())
                        Text("Start")
                            .font(Font.body.bold())
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled((myWorkout.exercises?.count ?? 0) < 1 || !workout.hasAuthorization())
                .opacity((myWorkout.exercises?.count ?? 0) < 1 || !workout.hasAuthorization() ? 0.5 : 1)
                .padding([.top, .bottom])

                // Prompt user to give the app access to health data.
                if (!workout.hasAuthorization()) {
                    Text("Grant access to all health data to start.\n\nSettings > Health > Apps > Workout Planner > Turn On All")
                }

                // Displays if there are any warm-ups/cool-downs in the workout.
                HStack {
                    Spacer()
                    if (myWorkout.warmUp == StretchLength.none.id) {
                        Text("No\nwarm-up")
                            .frame(width: 75)
                    } else {
                        Text("\(myWorkout.warmUp!)\nwarm-up")
                            .frame(width: 75)
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    if (myWorkout.coolDown == StretchLength.none.id) {
                        Text("No\ncool-down")
                            .frame(width: 75)
                    } else {
                        Text("\(myWorkout.coolDown!)\ncool-down")
                            .frame(width: 75)
                    }
                    Spacer()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

                Divider()

                // List of exercises in the workout.
                ForEach(myWorkout.exercises?.sortedArray(using:
                [NSSortDescriptor(keyPath: \Exercise.order, ascending: true)]) as! [Exercise],
                id: \.self)
                { exercise in
                    WorkoutExerciseRow(exercise: exercise).environmentObject(profile)
                }

                // Toggle the favourite status of the workout.
                FavouriteButton(isSet: $myWorkout.isFavourite)
                    .padding([.top, .bottom])
            }
        }
        .navigationTitle(myWorkout.name ?? "")
        
        // Load the created workout into the workout manager.
        .onAppear {
            workout.myWorkout = myWorkout
            workout.mode = .stopped
        }
    }
}
