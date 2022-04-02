//
//  ToArray.swift
//  ToArray
//
//  Converts an NSSet to an array. CloudKit does not allow arrays to be stored.
//

import Foundation

func exercisesToArray(exercises: NSSet) -> [Exercise] {
    return exercises.sortedArray(using: [NSSortDescriptor(keyPath: \Exercise.order,
                                                          ascending: true)]) as! [Exercise]
}

func stretchesToArray(stretches: NSSet, period: StretchPeriod) -> [Stretch] {
    let allStretches = stretches.sortedArray(using: [NSSortDescriptor(keyPath: \Stretch.order,
                                                          ascending: true)]) as! [Stretch]
    
    // Only return the stretches generated for either the warm-up or cooldown.
    return allStretches.filter({ $0.type == period.id })
}
