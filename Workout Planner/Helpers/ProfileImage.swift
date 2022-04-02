//
//  ProfileImage.swift
//  Workout Planner
//
//  Draws a circle and adds shadow around the user's profile picture.
//

import SwiftUI

struct ProfileImage: View {

    var image: UIImage?
    var size: CGFloat

    var body: some View {
        Image(uiImage: image ?? UIImage(imageLiteralResourceName: "defaultProfilePicture"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size, alignment: .center)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: size/50))
            .shadow(radius: 7)
    }
}
