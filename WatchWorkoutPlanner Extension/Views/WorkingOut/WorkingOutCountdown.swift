//
//  WorkingOutCountdown.swift
//  WorkingOutCountdown
//
//  Countdown displayed when a user starts a workout.
//

import SwiftUI

struct WorkingOutCountdown: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var workout: WorkoutManager
    @EnvironmentObject var motion: MotionManager
    @EnvironmentObject var profile: Profile

    var body: some View {
        TimelineView(NumbersTimelineSchedule(from: workout.builder?.startDate ?? Date())) { context in

            // Timer placed within a button to allow the user to skip the countdown and start the
            // workout.
            Button {
                startWorkout(workout: workout, motion: motion)
            } label : {
                ZStack {
                    
                    // Empty navigation link to push to the main workout view once the pre-workout
                    // countdown has finished.
                    NavigationLink(destination: WorkingOutHome().environmentObject(profile),
                                   isActive: $workout.showingWorkoutHome) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    // Empty navigation link to push to the stretching view once the pre-workout
                    // countdown has finished.
                    NavigationLink(destination: StretchingHome(stretches: workout.stretchPeriod == .warmUp
                                                               ? workout.warmUpArray : workout.coolDownArray),
                                   isActive: $workout.showingStretchingHome) {
                        EmptyView()
                    }
                    .opacity(0)

                    // 3 second timer.
                    CountdownBar(progress: workout.preWorkoutCountdown.secondsElapsed / 3,
                                 size: WKInterfaceDevice.current().screenBounds.width * 0.7)

                    Circle()
                        .fill(Color(white: 0.1))
                        .frame(width: WKInterfaceDevice.current().screenBounds.width * 0.6,
                               height: WKInterfaceDevice.current().screenBounds.width * 0.6)
                    
                    Text(String(Int(workout.preWorkoutCountdown.secondsElapsed + 0.99)))
                        .font(Font.monospacedDigit(Font.system(
                            size: WKInterfaceDevice.current().screenBounds.width * 0.5).weight(.bold))())
                        .foregroundColor(.primary)

                        // Start workout when the countdown timer has finished.
                        .onChange(of: workout.preWorkoutCountdown.secondsElapsed, perform: { value in
                            if (workout.preWorkoutCountdown.secondsElapsed <= 0 &&
                            workout.preWorkoutCountdown.mode == .running) {
                                startWorkout(workout: workout, motion: motion)
                            }
                        })
                }
            }
            .buttonStyle(.borderless)
        }
        .navigationBarBackButtonHidden(true)
        .opacity(workout.mode == .running ? 1 : 0)
        
        // Navigate back to workout detail if the workout has finished or been cancelled.
        .onAppear {
            if (workout.mode == .finished || workout.mode == .cancelled) {
                dismiss()
                workout.resetWorkout()
            }
        }
    }
}
