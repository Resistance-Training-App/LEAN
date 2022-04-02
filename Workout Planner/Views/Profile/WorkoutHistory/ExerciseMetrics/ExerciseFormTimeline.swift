//
//  ExerciseFormTimeline.swift
//  Workout Planner
//
//  Displays a timeline of exercise form during the workout.
//

import SwiftUI

struct ExerciseFormTimeline: View {
    
    let exercise: Exercise
    let index: Int
    var formTypes: [String]
    let colours: [Color]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(exercise.metricsArray[index].results?.indices ?? 0..<0, id: \.self) { i in
                    Rectangle()
                        .fill(colours[formTypes.firstIndex(of: exercise.metricsArray[index].results?[i] ?? "") ?? 0])
                        .frame(width: CGFloat(Int(geometry.size.width) /
                                              (exercise.metricsArray[index].results?.count ?? 0)), height: 20)
                        .if (i == 0) {
                            $0.cornerRadius(10, corners: [.topLeft, .bottomLeft])
                        }
                        .if (i == (exercise.metricsArray[index].results?.count ?? 0) - 1) {
                            $0.cornerRadius(10, corners: [.topRight, .bottomRight])
                        }
                }
            }
        }
    }
}

// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
