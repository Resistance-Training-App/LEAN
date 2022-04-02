//
//  RepCounter.swift
//  WatchWorkoutPlanner Extension
//
//  Locates and counts repetitions during a window of motion.
//

import Foundation

func repCounter(motion: MotionManager) {
    
    // Moving average size
    let avg_window = 10

    // The number of values either side of the current value to check if the current value is a
    // turning point.
    let scope = 2

    // Create moving average buffer to smooth data.
    let avgRepBuffer: [Double] = movingAverage(data: motion.repBuffer, scope: avg_window)

    // The index in the buffer where iteration will begin to look for turning points.
    let startingPoint = motion.turningPoints.count > 1 ? motion.turningPoints.last! + scope : scope

    // Debug prints.
    /*
    print("New TPs: \(turningPoints)")
    print("Starting Point: \(startingPoint)")
    print("Length avgRepBuffer: \(avgRepBuffer.count)")
    
    for i in 0...avgRepBuffer.count-1 {
        print("\(i): \(avgRepBuffer[i])")
    }
    */
    
    // Iterate through the average buffer.
    for i in startingPoint...avgRepBuffer.count - 1 - scope {
        
        // Found a turning point.
        if isTurningPoint(data: avgRepBuffer, index: i, scope: scope) {
            
            // Adjust index to account for the data shift with a moving average.
            if (i < avgRepBuffer.count - 1 - avg_window / 2) {
                motion.turningPoints.append(i + avg_window / 2)
            } else {
                motion.turningPoints.append(avgRepBuffer.count - 1)
            }
        }

        // Rep found if there are three turning points in the buffer.
        if (motion.turningPoints.count == 3) {
            let points: [Double] = [avgRepBuffer[motion.turningPoints[0]],
                                    avgRepBuffer[motion.turningPoints[1]],
                                    avgRepBuffer[motion.turningPoints[2]]]
            
            // Height of each part of the possible rep (eccentric and concentric motions)
            let height1 = abs(points[0] - points[1])
            let height2 = abs(points[1] - points[2])

            // If there was signifiant movement, count the rep (reduces false positives).
            if (height1 > motion.repThreshold && height2 > motion.repThreshold) {
                motion.repCount += 1
                motion.repStartTimes.append(motion.timeBuffer[motion.turningPoints[0]])
                motion.repMiddleTimes.append(motion.timeBuffer[motion.turningPoints[1]])
                motion.repEndTimes.append(motion.timeBuffer[motion.turningPoints[2]])

                // Calculate the range of motion of the rep.
                let rangeOfMotion = getRangeOfMotion(motion: motion,
                                                     repStartTime: motion.repStartTimes.last ?? 0,
                                                     repEndTime: motion.repEndTimes.last ?? 0)
                if rangeOfMotion > 0 {
                    motion.repRangeOfMotions.append(rangeOfMotion)
                }
                 
                // Remove first two turning points as the third could part of a next rep.
                motion.turningPoints.removeFirst(2)
            } else {
                
                // Just remove the first turning point if not considered a rep as the next two could
                // be part of a rep.
                motion.turningPoints.removeFirst()
            }
        }
    }

    // Remove part of the buffer that has been processed and contain no more potential reps.
    if (motion.turningPoints.count > 0) {
        let firstTurningPoint = motion.turningPoints.first!

        motion.repBuffer.removeFirst(motion.turningPoints.first!)
        motion.timeBuffer.removeFirst(motion.turningPoints.first!)
        motion.rangeBuffer.removeFirst(motion.turningPoints.first!)

        motion.turningPoints = motion.turningPoints.map { $0 - firstTurningPoint }
    } else {
        motion.repBuffer.removeAll()
        motion.timeBuffer.removeAll()
        motion.rangeBuffer.removeAll()
    }
}
