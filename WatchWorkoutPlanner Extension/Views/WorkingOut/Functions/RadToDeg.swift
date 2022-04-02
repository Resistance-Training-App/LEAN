//
//  RadToDeg.swift
//  WatchWorkoutPlanner Extension
//
//  Converts from radians to degrees.
//

import Foundation

func radToDeg(angle: Double) -> Double {
    return angle * 180 / .pi
}
