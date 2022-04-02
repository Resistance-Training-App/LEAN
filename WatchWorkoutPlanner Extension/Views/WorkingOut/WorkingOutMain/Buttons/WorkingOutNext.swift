//
//  WorkingOutNext.swift
//  WorkingOutNext
//
//  Navigate to the next exercise or finish the workout if the user is on the last exercise of
//  the workout.
//

import SwiftUI

struct WorkingOutNext: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile
    
    @State private var showingAlert = false
    @State private var adviceMessage = ""
    
    var body: some View {
        ZStack {

            // Finish button.
            if (workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1 &&
            workout.currentExerciseSet+1 == workout.myWorkout.exerciseArray[workout.currentExercise].weight?.count &&
            workout.currentSet == workout.myWorkout.sets-1 &&
            workout.myWorkout.coolDown == StretchLength.none.id) {
                Button(action: {
                    
                    // Save metrics of latest exercise.
                    saveMetrics(workout: workout, motion: motion, viewContext: viewContext)
                    
                    // Discard workout if the time working out is less than 10 seconds.
                    if ((workout.builder?.elapsedTime ?? 0) < 10) {
                        workout.cancelWorkout()
                    } else {
                        workout.endWorkout()
                    }
                    motion.pauseUpdates()
                }) {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                
            // Start cooldown button.
            } else if (workout.currentExercise == (workout.myWorkout.exercises?.count ?? 0)-1 &&
            workout.currentExerciseSet+1 == workout.myWorkout.exerciseArray[workout.currentExercise].weight?.count &&
            workout.currentSet == workout.myWorkout.sets-1 &&
            workout.myWorkout.coolDown != StretchLength.none.id) {
                
                Button {

                    // Save metrics of latest exercise.
                    saveMetrics(workout: workout, motion: motion, viewContext: viewContext)

                    workout.startCooldown()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)

            // Next exercise button.
            } else {
                Button(action: {

                    // Save metrics of latest exercise.
                    saveMetrics(workout: workout, motion: motion, viewContext: viewContext)
                    
                    // Send an alert to the user if bad from was detected.
                    if (workout.myWorkout.exerciseArray[workout.currentExercise].isLearnt) {
                        adviceMessage = checkBadForm(showingAlert: &showingAlert,
                                                     profile: profile,
                                                     results: motion.metrics[workout.currentExercise][workout.currentExerciseSet].results ?? [])
                    }
                    
                    nextExercise(workout: workout,
                                 motion: motion,
                                 countdownTime: profile.countdown,
                                 viewContext: viewContext)
                }) {
                    Image(systemName: "arrow.forward.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .disabled(workout.mode == .running ? false : true)
            }
        }
        .padding(.trailing)
        
        // Form advice alert.
        .alert("Form advice:\n\(adviceMessage)", isPresented: $showingAlert) {
            Button("Ok") {}
            
            // Disable form advice alerts.
            Button("Leave me to it") {
                profile.formAdviceAlerts = false
                
                do { try viewContext.save() } catch {
                    print(error.localizedDescription)
                }
                PersistenceController.shared.save()
            }
        }
    }
}
