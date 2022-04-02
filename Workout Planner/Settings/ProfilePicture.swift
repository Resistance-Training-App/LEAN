//
//  ProfilePicture.swift
//  ProfilePicture
//

import SwiftUI

struct ProfilePicture: View {
    
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var profile: Profile
    
    @Binding var profileData: Profile.Template
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        HStack {
            Spacer()
                
            // Profile Picture
            ProfileImage(image: UIImage(data: profileData.picture) ?? nil , size: 100)

            Spacer()

            VStack {
                Spacer()
                
                // Edit Picture
                Button(action: {
                    showPhotoLibrary = true
                }) {
                    Text("Edit")
                        .font(.headline)
                        .frame(width: 80, height: 30, alignment: .center)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Delete picture and revert to the default profile picture.
                Button(action: {
                    profileData.picture = Data.init()
                }) {
                    Text("Remove")
                        .font(.headline)
                        .frame(width: 80, height: 30, alignment: .center)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(profileData.picture.count <= 0)
                
                Spacer()
            }
            Spacer()
        }
        
        // Sheet displayed when the user is picking a picture for their profile picture from their
        // photo library.
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
                .onDisappear {
                    profileData.picture = image.pngData() ?? profileData.picture
                }
                .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                            profile.theme == Themes.light.id ? .light : .dark)
        }
        .padding()
    }
}
