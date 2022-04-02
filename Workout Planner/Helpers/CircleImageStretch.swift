//
//  CircleImageStretch.swift
//  Workout Planner
//
//  Draws a circle and adds shadow around a stretch image.
//

import SwiftUI

struct CircleImageStretch: View {

    @ObservedObject var stretch: Stretch
    var size: CGFloat

    var body: some View {
        Image(uiImage: stretch.picture != nil ?
                       UIImage(data: stretch.picture ?? Data.init())! :
                       UIImage(named: stretch.name ?? "") ?? UIImage())
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.blue, lineWidth: size/20))
            .shadow(radius: 3)
    }
}
