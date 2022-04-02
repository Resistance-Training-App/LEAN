//
//  WorkingOutExit.swift
//  Workout Planner
//
//  Button used to exit the workout at any time.
//

import SwiftUI

struct WorkingOutExit: View {

    @EnvironmentObject var workout: WorkoutManager

    @Binding var showingAlert: Bool
    
    // Displays an alert confirming you want to finish the workout early.
    var alert: Alert {
        Alert(
            title: Text("Stop Workout"),
            message: Text("Exit the workout early?"),
            primaryButton: .destructive(Text("Yes"), action: {
                if (workout.timer.secondsElapsed < 10) {
                    workout.cancelWorkout()
                } else {
                    workout.endWorkout()
                }
            }),
            secondaryButton: .default(Text("No"), action: { workout.resume() })
        )
    }

    var body: some View {
        Button {
            
            // Pause the workout while the user is deciding if they want to end the workout early.
            workout.pause()
            showingAlert.toggle()
        } label: {
            Text("Exit")
                .font(.system(size: 18))
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .alert(isPresented: $showingAlert, content: { alert })
    }
}
