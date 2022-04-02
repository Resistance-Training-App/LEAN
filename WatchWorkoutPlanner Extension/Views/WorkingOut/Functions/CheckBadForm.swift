//
//  CheckBadForm.swift
//  WatchWorkoutPlanner Extension
//
//  Give advice to the user on form based on the previous exercise set.
//

import Foundation

func checkBadForm(showingAlert: inout Bool,
                  profile: Profile,
                  results: [String]) -> String {
    
    // Only advice on form is the user has opted for it.
    if (profile.formAdviceAlerts) {
        if (results.contains("TooFast")) {
            showingAlert = true
            return "Try to slow down your reps and keep the weights under control."
        } else if (results.contains("BadRange") || results.contains("InsufficientRange")) {
            showingAlert = true
            return "Try to increase your range of motion."
        }
    }
    
    return ""
}
