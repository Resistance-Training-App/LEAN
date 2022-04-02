//
//  ConditionalFormat.swift
//  Workout Planner
//
//  Default view to define the 'if' function to be able to format items conditionally.
//

import SwiftUI

struct ConditionalFormat: View {
    var body: some View {
        Text("")
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
