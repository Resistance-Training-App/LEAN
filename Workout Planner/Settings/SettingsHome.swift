//
//  SettingsHome.swift
//  Workout Planner
//
//  The main view for the settings page.
//

import SwiftUI

struct SettingsHome: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profile: Profile

    @Binding var profileData: Profile.Template

    var body: some View {
        List {

            // Profile picture.
            // Decided it wasn't needed at this current time in the project.
            //ProfilePicture(profileData: $profileData)

            // Profile details and preferences.
            ProfileDetails(profileData: $profileData)            
        }
        .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                    profile.theme == Themes.light.id ? .light : .dark)
    }
}
