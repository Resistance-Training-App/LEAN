//
//  TimerManager.swift
//  Workout Planner
//
//  A timer class used to time the user's workouts.
//

import SwiftUI

enum timerMode {
    case running
    case stopped
    case paused
}

class TimerManager: ObservableObject {
    
    @Published var mode: timerMode = .stopped
    @Published var secondsElapsed = 0.0
    
    var timer = Timer()
    
    // Start a timer counting up.
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed += 0.1
        }
    }
    
    // Start a timer counting down from the time provided.
    func start(secondsElapsed: Double) {

        self.secondsElapsed = secondsElapsed

        if (mode != .running) {
            mode = .running
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { countdown in
                if (secondsElapsed <= 0) {
                    self.stop()
                }
                self.secondsElapsed -= 0.1
            }
        }
    }
    
    // Pause the timer.
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    // Stop the timer.
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
    
    // Restart the timer.
    func restart() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed += 0.1
        }
    }
    
    // Restart the timer.
    func restart(secondsElapsed: Double) {
        timer.invalidate()
        self.secondsElapsed = secondsElapsed
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if (secondsElapsed <= 0) {
                self.stop()
            }
            self.secondsElapsed -= 0.1
        }
    }
}
