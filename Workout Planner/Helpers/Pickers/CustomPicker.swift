//
//  CustomPicker.swift
//  Workout Planner
//
//  Modified solution from https://stackoverflow.com/questions/70328016/clickable-area-of-swiftui-picker-overlapping
//

import Foundation
import SwiftUI

struct CustomPicker: View {

    @Binding var selection: Double

    let list: [Double]
    let unit: String
    
    var body: some View {
        BasePicker(selecting: $selection, data: list, unit: unit)
            .frame(width: UIScreen.main.bounds.size.width / 4)
            .cornerRadius(16)
    }
}

struct CustomIntPicker: View {

    @Binding var selection: Int

    let list: [Int]
    let unit: String
    
    var body: some View {
        BaseIntPicker(selecting: $selection, data: list, unit: unit)
            .frame(width: UIScreen.main.bounds.size.width / 4)
            .cornerRadius(16)
    }
}
