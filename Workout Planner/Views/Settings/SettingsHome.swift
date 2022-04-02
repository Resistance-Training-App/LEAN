//
//  SettingsHome.swift
//  Workout Planner
//
//  The main view for the settings page.
//
//  Created by William Coates on 13/07/2021.
//

import SwiftUI

struct SettingsHome: View {
    
    @Binding var profileData: Profile.Template
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        
        List {
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
            .padding()

            // First name
            HStack {
                Text("First name").bold()
                Divider()
                    .frame(height: 25)
                TextField("First name", text: $profileData.firstName)
            }
            .padding()
            
            // Last name
            HStack {
                Text("Last name").bold()
                Divider()
                    .frame(height: 25)
                TextField("Last name", text: $profileData.lastName)
            }
            .padding()
            
            // Email
            HStack {
                Text("Email").bold()
                Divider()
                    .frame(height: 25)
                TextField("Email", text: $profileData.email)
            }
            .padding()
            
            // Enable or disable notifications
            Toggle(isOn: $profileData.prefersNotifications) {
                Text("Enable Notifications").bold()
            }
            .padding()
            
            // Unit of measurement for the weight of dumbbells, barbells etc.
            VStack(alignment: .leading, spacing: 20) {
                Text("Weight Units").bold()
                
                Picker("Units", selection: $profileData.weightUnit) {
                        Text("Kilograms").tag(Profile.Units.kilograms)
                        Text("Pounds").tag(Profile.Units.pounds)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
                .onDisappear {
                    profileData.picture = image.pngData() ?? profileData.picture
                }
        }
    }
}

struct SettingsHome_Previews: PreviewProvider {
    static var previews: some View {
        SettingsHome(profileData: .constant(Profile.Template.init()))
    }
}
