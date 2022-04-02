//
//  AddSpaces.swift
//  WatchWorkoutPlanner Extension
//
//  Adds spaces to strings before any uppercase letters that are not are the start of the string.
//

import Foundation

func addSpaces(text: String) -> String {

    if (text.count == 0) {
           return ""
    }
    
    let textArray = Array(text)
    var newText: String = ""

    for (i, char) in text.enumerated() {
        if i != 0 {
            if (char.isUppercase && textArray[i-1] != " " && textArray[i-1] != "/") {
                newText = newText.appending(" ")
            }
        }
        newText = newText.appending(String(textArray[i]))
    }

    return newText
}
