//
//  FormatDate.swift
//  Workout Planner
//
//  Functions to format dates in a more readable format.
//

import Foundation

func formatDate(date : Date) -> String {

    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let withinToday = DateFormatter()
    withinToday.dateFormat = "HH:mm"
    
    let withinWeek = DateFormatter()
    withinWeek.dateFormat = "EEEE"
    
    let withinYear = DateFormatter()
    withinYear.dateFormat = "dd MMMM"
    
    let other = DateFormatter()
    other.dateFormat = "dd/MM/yyyy"
    
    if (Calendar.current.isDateInToday(date)) {
        return withinToday.string(from: date)
    } else if (Calendar.current.isDateInYesterday(date)) {
        return "Yesterday"
    } else if (date.timeIntervalSinceNow > -604800) {
        return withinWeek.string(from: date)
    } else if (date.timeIntervalSinceNow > -31536000) {
        return withinYear.string(from: date)
    } else {
        return other.string(from: date)
    }
}
