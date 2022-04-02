//
//  WorkoutAddFirstPrompt.swift
//  Workout Planner
//
//  Prompts the user to add their first workout when they haven't add a workout before and have not
//  completed a workout before.
//

import SwiftUI

struct WorkoutAddFirstPrompt: View {
    
    @EnvironmentObject var profile: Profile
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("Create your first workout here")
                        .padding(.top, 75)
                    Spacer()
                }
                VStack {
                    Image("arrow\(colorScheme == .light ? "Light" : "Dark")")
                        .resizable()
                        .frame(width: 133, height: 100)
                        .padding(.trailing)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
