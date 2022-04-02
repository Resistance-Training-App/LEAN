//
//  MotionManager.swift
//  MotionManager
//
//  Manages and processes incoming motion data from the Apple Watch.
//

import Foundation
import CoreMotion
import WatchKit
import CoreML

class MotionManager: ObservableObject {

    let motionManager = CMMotionManager()
    let modelManager = ModelManager()
    let queue = OperationQueue()

    // Setting will be included in complete app to allow this to be changed.
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    
    var justWorkout = false

    var currentIndexInPredictionWindow = 0
    var buffer = Motion()
    var bufferCopy = Motion()
    var isRunning = false

    var repCount = 0
    var turningPoints: [Int] = []
    var repThreshold: Double = 0.5
    var repBuffer: [Double] = []
    var timeBuffer: [Double] = []
    var rangeBuffer: [Double] = []
    var repStartTimes: [Double] = []
    var repMiddleTimes: [Double] = []
    var repEndTimes: [Double] = []
    var repRangeOfMotions: [Double] = []

    var motionTypes: [String] = []
    var exerciseResults: [String] = []
    var results: [String] = []
    var distribution: [[Double]] = []

    var metrics: [[Metrics]] = []

    init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }

    // Start motion recording.
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }

        motionManager.deviceMotionUpdateInterval = ModelManager.sensorsUpdateFrequency

        motionManager.startDeviceMotionUpdates(to: queue) { [self] (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }

            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
            self.isRunning = true
        }
    }
    
    // Pause motion recording.
    func pauseUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
            self.isRunning = false
        }
    }

    // Stop motion recording.
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
            self.isRunning = false
        }

        currentIndexInPredictionWindow = 0
        buffer = Motion()

        repCount = 0
        turningPoints = []
        repBuffer = []
        timeBuffer = []
        rangeBuffer = []
        repStartTimes = []
        repMiddleTimes = []
        repEndTimes = []
        repRangeOfMotions = []

        //motionTypes = []
        results = []
        distribution = []
    }
    
    // Remove saved results ready for the next exercise.
    func clearResults() {
        self.repCount = 0
        self.turningPoints.removeAll()
        self.repBuffer.removeAll()
        self.timeBuffer.removeAll()
        self.rangeBuffer.removeAll()
        self.repStartTimes.removeAll()
        self.repMiddleTimes.removeAll()
        self.repEndTimes.removeAll()
        self.repRangeOfMotions.removeAll()
        self.motionTypes.removeAll()
        self.results.removeAll()
        self.distribution.removeAll()
    }
    
    // Process incoming motion data.
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
                        
        DispatchQueue.global().async {

            // If data array is full, execute a prediction and count any possible reps.
            if (self.currentIndexInPredictionWindow == ModelManager.predictionWindowSize) {
                
                // Make a copy of the motion that needs to be processed.
                self.bufferCopy.DMUAccelX = self.buffer.DMUAccelX
                self.bufferCopy.DMUAccelY = self.buffer.DMUAccelY
                self.bufferCopy.DMUAccelZ = self.buffer.DMUAccelZ
                self.bufferCopy.DMGrvX = self.buffer.DMGrvX
                self.bufferCopy.DMGrvY = self.buffer.DMGrvY
                self.bufferCopy.DMGrvZ = self.buffer.DMGrvZ
                self.bufferCopy.DMRotY = self.buffer.DMRotY
                self.bufferCopy.DMRotZ = self.buffer.DMRotZ
                self.bufferCopy.DMRoll = self.buffer.DMRoll
                self.bufferCopy.TimeStamp = self.buffer.TimeStamp
                
                // Update buffers to only include the second half of what's currently in the buffer.
                // This is done because the sliding windows are overlapped.
                self.buffer.DMUAccelX = Array(self.buffer.DMUAccelX[ModelManager.predictionWindowOverlap...])
                self.buffer.DMUAccelY = Array(self.buffer.DMUAccelY[ModelManager.predictionWindowOverlap...])
                self.buffer.DMUAccelZ = Array(self.buffer.DMUAccelZ[ModelManager.predictionWindowOverlap...])
                self.buffer.DMGrvX = Array(self.buffer.DMGrvX[ModelManager.predictionWindowOverlap...])
                self.buffer.DMGrvY = Array(self.buffer.DMGrvY[ModelManager.predictionWindowOverlap...])
                self.buffer.DMGrvZ = Array(self.buffer.DMGrvZ[ModelManager.predictionWindowOverlap...])
                self.buffer.DMRotY = Array(self.buffer.DMRotY[ModelManager.predictionWindowOverlap...])
                self.buffer.DMRotZ = Array(self.buffer.DMRotZ[ModelManager.predictionWindowOverlap...])
                self.buffer.DMRoll = Array(self.buffer.DMRoll[ModelManager.predictionWindowOverlap...])
                self.buffer.TimeStamp = Array(self.buffer.TimeStamp[ModelManager.predictionWindowOverlap...])

                // Start a new prediction window from scratch
                self.currentIndexInPredictionWindow = ModelManager.predictionWindowOverlap
                
                processBuffer(motion: self)

                // Only store current prediction distribution.
                if self.results.count > 1 && self.distribution.count > 1 {
                    self.distribution.removeFirst()
                }
                
                // Clear buffer copies
                self.bufferCopy.DMUAccelX.removeAll()
                self.bufferCopy.DMUAccelY.removeAll()
                self.bufferCopy.DMUAccelZ.removeAll()
                self.bufferCopy.DMGrvX.removeAll()
                self.bufferCopy.DMGrvY.removeAll()
                self.bufferCopy.DMGrvZ.removeAll()
                self.bufferCopy.DMRotY.removeAll()
                self.bufferCopy.DMRotZ.removeAll()
                self.bufferCopy.DMRoll.removeAll()
                self.bufferCopy.TimeStamp.removeAll()
            }
            
            // Only store the motion values that are being used in motion classification models.
            self.buffer.DMUAccelX.append(deviceMotion.userAcceleration.x as Double)
            self.buffer.DMUAccelY.append(deviceMotion.userAcceleration.y as Double)
            self.buffer.DMUAccelZ.append(deviceMotion.userAcceleration.z as Double)
            self.buffer.DMGrvX.append(deviceMotion.gravity.x as Double)
            self.buffer.DMGrvY.append(deviceMotion.gravity.y as Double)
            self.buffer.DMGrvZ.append(deviceMotion.gravity.z as Double)
            self.buffer.DMRotY.append(deviceMotion.rotationRate.y as Double)
            self.buffer.DMRotZ.append(deviceMotion.rotationRate.z as Double)
            self.buffer.DMRoll.append(deviceMotion.attitude.roll as Double)
            self.buffer.TimeStamp.append(Date().timeIntervalSince1970 as Double)
            
            // Update prediction array index
            self.currentIndexInPredictionWindow += 1
        }
    }
}
