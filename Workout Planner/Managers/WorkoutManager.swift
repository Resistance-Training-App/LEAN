//
//  WorkoutManager.swift
//  WorkoutManager
//
//  A class to manage a workout's attributes and control the workout such as pausing or resetting
//  workout.
//

import Foundation
import Combine

enum WorkoutMode {
    case running
    case stopped
    case paused
    case finished
}

class WorkoutManager: ObservableObject {

    @Published var showingCountdown: Bool = false
    @Published var showingStretchingHome: Bool = false
    @Published var showingWorkoutHome: Bool = false
    @Published var showingSummaryView: Bool = false
    @Published var myWorkout: Workout = Workout.init()
    @Published var warmUpArray: [Stretch] = []
    @Published var coolDownArray: [Stretch] = []
    @Published var currentStretch: Int = 0
    @Published var currentExercise: Int = 0
    @Published var currentExerciseSet: Int = 0
    @Published var currentSet: Int = 0
    @Published var secondsLeft: Int = 0
    @Published var timeDone: Int = 0
    @Published var mode: WorkoutMode = .stopped
    @Published var preWorkoutCountdown: TimerManager = TimerManager()
    @Published var timer: TimerManager = TimerManager()
    @Published var countdown: TimerManager = TimerManager()
    @Published var preCountdown: TimerManager = TimerManager()
    @Published var stretchPeriod: StretchPeriod = StretchPeriod.warmUp
    
    var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = timer.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    // Start the cooldown after the workout.
    func startCooldown() {
        stretchPeriod = .coolDown
        currentStretch = 0
        preWorkoutCountdown.stop()
        countdown.stop()
        showingWorkoutHome = false
        showingStretchingHome = true
    }

    // Start the workout.
    func startWorkout() {
        self.showingCountdown = true
        self.mode = .running
        self.warmUpArray = stretchesToArray(stretches: myWorkout.stretches ?? [],
                                            period: StretchPeriod.warmUp)
        self.coolDownArray = stretchesToArray(stretches: myWorkout.stretches ?? [],
                                              period: StretchPeriod.coolDown)
        self.secondsLeft = Int(myWorkout.time)
        self.preWorkoutCountdown.start(secondsElapsed: 3)
        self.timer.start()
    }

    // Pause the workout.
    func pause() {
        mode = .paused
        timer.pause()
    }

    // Resume the workout.
    func resume() {
        mode = .running
        timer.start()
    }

    // End the workout.
    func endWorkout() {
        mode = .finished
        timer.pause()
        showingWorkoutHome = false
        showingStretchingHome = false
        showingSummaryView = true
    }

    // Reset workout attribute's so it's ready for a new workout to be started.
    func resetWorkout() {
        currentExercise = 0
        currentStretch = 0
        currentSet = 0
        currentExerciseSet = 0
        secondsLeft = 0
        timeDone = 0
        mode = .stopped
        stretchPeriod = .warmUp
        timer.stop()
        countdown.stop()
        preCountdown.stop()
    }
    
    // Restart the workout.
    func restartWorkout(countdownTime: Double) {
        currentExercise = 0
        currentStretch = 0
        currentSet = 0
        currentExerciseSet = 0
        timeDone = 0
        countdown.stop()
        
        if ((showingStretchingHome && stretchPeriod == .warmUp) || warmUpArray.isEmpty) {
            timer.restart()
        }

        if (myWorkout.exerciseArray.first!.isHold && showingWorkoutHome) {
            if (countdownTime > 0) {
                preCountdown.start(secondsElapsed: countdownTime)
            } else {
                countdown.start(secondsElapsed: myWorkout.exerciseArray[currentExercise].repTime)
            }
        } else if (showingStretchingHome) {
            if (countdownTime > 0) {
                preCountdown.start(secondsElapsed: countdownTime)
            } else {
                countdown.start(secondsElapsed: stretchPeriod == .warmUp ?
                    warmUpArray[currentStretch].repTime : coolDownArray[currentStretch].repTime)
            }
        } else {
            preCountdown.stop()
        }
    }
    
    // Cancel the workout and discard the data collected from it instead of saving as a workout
    // history.
    func cancelWorkout() {
        currentExercise = 0
        currentStretch = 0
        currentSet = 0
        currentExerciseSet = 0
        secondsLeft = 0
        timeDone = 0
        mode = .stopped
        timer.stop()
        countdown.stop()
        preCountdown.stop()
        showingWorkoutHome = false
        showingStretchingHome = false
    }
}
