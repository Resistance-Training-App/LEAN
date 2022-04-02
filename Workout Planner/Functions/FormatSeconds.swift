//
//  FormatSeconds.swift
//  Workout Planner
//
//  Function to convert seconds from an integer to a formatted time string
//

import Foundation

func formatSeconds(seconds : Int) -> String {
    
    if (seconds < 3600) {
        return String(format: "%02d:%02d",
                      ((seconds % 3600) / 60), (seconds % 3600) % 60)
    } else {
        return String(format: "%02d:%02d:%02d",
                      (seconds / 3600), ((seconds % 3600) / 60), (seconds % 3600) % 60)
    }
}
