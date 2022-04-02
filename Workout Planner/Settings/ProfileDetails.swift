//
//  ProfileDetails.swift
//  ProfileDetails
//
//  Allows the user to edit profile details and preferences.
//

import SwiftUI

struct ProfileDetails: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profile: Profile

    @Binding var profileData: Profile.Template
    
    @State private var showingCountdownAlert = false
    
    // Alert to explain what the countdown timer used for.
    var countdownAlert: Alert {
        Alert(title: Text("Countdown Timer"),
              message: Text("The time given to you to prepare for a timed exercise or stretch."),
              dismissButton: .default(Text("Dismiss")))
    }
    
    var body: some View {

        // Enable or disable form advice alerts when working out with the Apple Watch.
        Toggle(isOn: $profileData.formAdviceAlerts) {
            Text("Form Advice Alerts").bold()
        }
        .padding()

        // The amount of time given to the user to prepare for a timed exercise or stretch.
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Countdown Timer").bold()

                Button(action: {
                    showingCountdownAlert.toggle()
                }) {
                    Image(systemName: "info.circle")
                }
                .alert(isPresented: $showingCountdownAlert, content: { countdownAlert })
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            
            HStack {
                Spacer()
                if (profileData.countdown == 0) {
                    Text("None")
                } else {
                    Text("\(Int(profileData.countdown)) second\(profileData.countdown > 1 ? "s" : "")")
                }
                Spacer()
            }

            Slider(value: $profileData.countdown, in: 0...30, step: 1) {
                Text("Rep Time")
            }
        }
        .padding()

        // Unit of measurement for the weight of dumbbells, barbells etc.
        VStack(alignment: .leading, spacing: 20) {
            Text("Weight Unit").bold()
            
            Picker("Units", selection: $profileData.weightUnit) {
                Text("Kilograms").tag(Units.kilograms.id)
                Text("Pounds").tag(Units.pounds.id)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()

        // Colour theme of application
        VStack(alignment: .leading, spacing: 20) {
            Text("Theme").bold()
            
            Picker("Themes", selection: $profileData.theme) {
                ForEach(Themes.allCases, id: \.id) { theme in
                    Text(theme.id)
                        .tag(theme.id)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: profileData.theme) { _ in updateTheme(profileData: profileData) }
        }
        .padding()
    }

    func updateTheme(profileData: Profile.Template) {
        profile.update(from: profileData)
        do { try viewContext.save() } catch {
            print(error.localizedDescription)
        }
        PersistenceController.shared.save()
    }
}
