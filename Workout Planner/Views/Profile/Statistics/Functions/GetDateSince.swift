//
//  GetDateSince.swift
//  Workout Planner
//
//  Function to return the current date subtracted by common time periods such as weeks and month.
//

import Foundation

func getDateSince(since: String) -> Date {

    switch since {
        case "allTime":
            return Date.distantPast
        case "year":
            return Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        case "month":
            return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        case "week":
            return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        default:
            return Date()
    }
}
