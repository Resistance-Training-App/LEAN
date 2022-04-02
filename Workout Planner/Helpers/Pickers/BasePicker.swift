//
//  BasePicker.swift
//  Workout Planner
//
//  Modified solution from https://stackoverflow.com/questions/70328016/clickable-area-of-swiftui-picker-overlapping
//

import Foundation
import SwiftUI

struct BasePicker: UIViewRepresentable {
    var selection: Binding<Double>
    let data: [Double]
    let unit: String
    
    init(selecting: Binding<Double>, data: [Double], unit: String) {
        self.selection = selecting
        self.data = data
        self.unit = unit
    }
    
    func makeCoordinator() -> BasePicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<BasePicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<BasePicker>) {
        guard let row = data.firstIndex(of: selection.wrappedValue) else { return }
        view.selectRow(row, inComponent: 0, animated: false)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: BasePicker
        
        init(_ pickerView: BasePicker) {
            parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 90
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.data[row].formatted() + " " + parent.unit
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection.wrappedValue = parent.data[row]
        }
    }
}

struct BaseIntPicker: UIViewRepresentable {
    var selection: Binding<Int>
    let data: [Int]
    let unit: String
    
    init(selecting: Binding<Int>, data: [Int], unit: String) {
        self.selection = selecting
        self.data = data
        self.unit = unit
    }
    
    func makeCoordinator() -> BaseIntPicker.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<BaseIntPicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<BaseIntPicker>) {
        guard let row = data.firstIndex(of: selection.wrappedValue) else { return }
        view.selectRow(row, inComponent: 0, animated: false)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: BaseIntPicker
        
        init(_ pickerView: BaseIntPicker) {
            parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 90
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return (parent.data[row] + 1).formatted() + " " + parent.unit
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection.wrappedValue = Int(parent.data[row])
        }
    }
}
