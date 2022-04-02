//
//  MostCommonForm.swift
//  WatchWorkoutPlanner Extension
//
//  Find the form that was performed most often during an exercise set not including 'Other'.
//

import Foundation

func mostCommonForm(formArray: [String]) -> String {
    
    var formTypes: [String:Int] = [:]
    
    let filteredFormArray = formArray.filter {$0 != "Other"}
    
    for form in filteredFormArray {
        if formTypes[form] != nil {
            formTypes[form]! += 1
        } else {
            formTypes[form] = 1
        }
    }
    
    let mostCommonForm = formTypes.max { a, b in a.value < b.value }
    
    return addSpaces(text: mostCommonForm?.key ?? "N/A")
}
