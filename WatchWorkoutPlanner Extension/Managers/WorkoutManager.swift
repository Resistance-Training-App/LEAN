//
//  WorkoutManager.swift
//  WorkoutManager
//
//  Class to manage a workout using Apple's 'HKWorkoutSession' to be able to access information
//  such as heart rate and allowing WatchOS to know a workout is running.
//

import Foundation
import HealthKit

enum WorkoutMode {
    case running
    case stopped
    case paused
    case finished
    case cancelled
}

class WorkoutManager: NSObject, ObservableObject {

    @Published var showingCountdown: Bool = false
    @Published var showingStretchingHome: Bool = false
    @Published var showingWorkoutHome: Bool = false
    @Published var showingSummaryView: Bool = false
    @Published var justWorkout: Bool = false
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
    @Published var countdown = TimerManager()
    @Published var preCountdown = TimerManager()
    @Published var stretchPeriod: StretchPeriod = StretchPeriod.warmUp
    @Published var currentWeightChoice: Double = 0.0

    let healthStore = HKHealthStore()
    let motion = MotionManager()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
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
        
        if (!self.justWorkout) {
            self.warmUpArray = stretchesToArray(stretches: myWorkout.stretches ?? [],
                                                period: StretchPeriod.warmUp)
            self.coolDownArray = stretchesToArray(stretches: myWorkout.stretches ?? [],
                                                  period: StretchPeriod.coolDown)
            self.secondsLeft = Int(myWorkout.time)
        }
        self.preWorkoutCountdown.start(secondsElapsed: 3)
    }
    
    // Function to start the timer after the pre-workout countdown has finished.
    func startTimer() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = HKWorkoutActivityType.traditionalStrengthTraining
        configuration.locationType = .indoor

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            print("Couldn't create workout session.")
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            print("Workout started.")
        }
    }

    // Request authorisation to access HealthKit.
    func requestAuthorization() {

        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorisation for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in

        }
    }

    // Function to check if the user has granted access to health data.
    func hasAuthorization() -> Bool {
        switch healthStore.authorizationStatus(for: HKQuantityType.workoutType()) {
            case .sharingAuthorized:
                return true
            case .sharingDenied:
                return false
            default:
                return false
        }
    }

    // Pause the workout.
    func pause() {
        session?.pause()
        mode = .paused
        if (preCountdown.mode == .running) {
            preCountdown.pause()
        }
        if (countdown.mode == .running) {
            countdown.pause()
        }
    }

    // Resume the workout.
    func resume() {
        session?.resume()
        mode = .running
        if (preCountdown.mode == .paused) {
            preCountdown.restart(secondsElapsed: preCountdown.secondsElapsed)
        }
        if (countdown.mode == .paused) {
            countdown.restart(secondsElapsed: countdown.secondsElapsed)
        }
    }

    // End the workout.
    func endWorkout() {
        session?.end()
        mode = .finished
        showingSummaryView = true
    }

    // Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var appleWorkout: HKWorkout?

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            default:
                return
            }
        }
    }

    // Reset the workout, used when a workout has finished and the workout's attributes need to be
    // reset.
    func resetWorkout() {
        currentExercise = 0
        currentStretch = 0
        currentSet = 0
        currentExerciseSet = 0
        secondsLeft = 0
        timeDone = 0
        builder = nil
        appleWorkout = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        mode = .stopped
        stretchPeriod = .warmUp
        preWorkoutCountdown.stop()
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
        
        if ((showingStretchingHome && stretchPeriod == .warmUp) || (showingWorkoutHome && warmUpArray.isEmpty)) {
            mode = .cancelled
            session?.end()
            builder = nil
            appleWorkout = nil
            session = nil
            activeEnergy = 0
            averageHeartRate = 0
            heartRate = 0
            countdown.stop()
        }
        
        mode = .running
        
        // Start the countdown if the first exercise is a hold.
        if (myWorkout.exerciseArray.first!.isHold && showingWorkoutHome) {
            if (countdownTime > 0) {
                preCountdown.start(secondsElapsed: countdownTime)
            } else {
                countdown.start(secondsElapsed: myWorkout.exerciseArray[currentExercise].repTime)
            }
        
        // Start the stretches if the workout has a warm-up.
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
        
        if (stretchPeriod == .warmUp || (showingWorkoutHome && warmUpArray.isEmpty)) {
            startTimer()
        }
    }
    
    // Cancel the workout, used when the user ends the workout within 10 seconds of starting it.
    func cancelWorkout() {
        currentExercise = 0
        currentStretch = 0
        currentSet = 0
        currentExerciseSet = 0
        secondsLeft = 0
        timeDone = 0
        builder = nil
        appleWorkout = nil
        session?.end()
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        mode = .cancelled
        preWorkoutCountdown.stop()
        countdown.stop()
        preCountdown.stop()
        showingCountdown = false
        showingWorkoutHome = false
        showingStretchingHome = false
    }
}

// HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                // Only save the workout is it was finished and lasted longer than 10 seconds.
                if (self.mode == .finished && Date().timeIntervalSince(workoutSession.startDate ?? Date.now) > 10) {
                    self.builder?.finishWorkout { (finishedWorkout, error) in
                        DispatchQueue.main.async {
                            self.appleWorkout = finishedWorkout
                        }
                    }
                } else if (self.mode == .cancelled) {
                    self.builder?.discardWorkout()
                }
            }
        }
    }

    // Save workout if interrupted by an error.
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        builder?.endCollection(withEnd: Date()) { (success, error) in
            self.builder?.finishWorkout { (finishedWorkout, error) in
                DispatchQueue.main.async {
                    self.appleWorkout = finishedWorkout
                }
            }
        }
        print(error)
    }
}

// HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}
