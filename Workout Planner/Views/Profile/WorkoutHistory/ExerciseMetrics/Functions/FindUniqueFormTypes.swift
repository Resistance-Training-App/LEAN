//
//  FindUniqueFormTypes.swift
//  Workout Planner
//
//  Find all unique types of form during an exercise set.
//

import Foundation

func findUniqueFormTypes(metrics: [Metrics]) -> [String] {

    var formTypes = Set<String>()
    
    for metric in metrics {
        for result in metric.results ?? [] {
            formTypes.insert(result)
        }
    }

    if formTypes.isEmpty {
        return []
    }

    // Reorganise order so form types 'Good' and 'Other' are always at the start and the rest are
    // sorted alphabetically.
    var formTypesArray = Array(formTypes).filter {$0 != "Good" && $0 != "Other"}.sorted()
    formTypesArray.insert("Good", at: 0)
    formTypesArray.insert("Other", at: 1)

    return formTypesArray
}
