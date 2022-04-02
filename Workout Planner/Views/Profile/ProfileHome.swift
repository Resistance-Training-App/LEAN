//
//  ProfileHome.swift
//  Workout Planner
//
//  The main view displayed for the user's profile page.
//

import SwiftUI
import CoreData

struct ProfileHome: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profile: Profile

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutHistory.timestamp, ascending: false)],
        animation: .default)
    var workoutHistories: FetchedResults<WorkoutHistory>
    
    @State private var showSettings = false
    @State private var profileData: Profile.Template = Profile.Template()

    var body: some View {
        NavigationView {
            ScrollView {

                // Top of profile including name and activity rings.
                ProfileTopHome(profile: profile, workoutHistories: Array(workoutHistories))

                // Workout history
                VStack {
                    HStack {
                        Text("History")
                            .font(.system(size: 25, weight: .semibold, design: .default))
                        Spacer()
                        NavigationLink(
                            destination: WorkoutHistoryHome(workoutHistories: Array(workoutHistories))) {
                            Text("Show More")
                        }
                    }
                    .padding()
                    WorkoutHistoryPreview(workoutHistories: workoutHistories)
                }

                // User statistics
                VStack {
                    HStack {
                        Text("Statistics")
                            .font(.system(size: 25, weight: .semibold, design: .default))
                        Spacer()
                        if (!workoutHistories.isEmpty) {
                            NavigationLink(
                                destination: StatisticsHome(workoutHistories: Array(workoutHistories))) {
                                Text("Show More")
                            }
                        }
                    }
                    .padding([.top, .leading, .trailing])
                    .padding(.bottom, -2)
                    if (!workoutHistories.isEmpty) {
                        StatisticsPreview(workoutHistories: Array(workoutHistories))
                    } else {
                        Text("Complete a workout to view statistics.")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            // Settings button.
            .navigationBarItems(
                trailing: Button(action: {
                    showSettings = true
                    profileData = profile.template
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                    }
            )
            
            // Settings page.
            .fullScreenCover(isPresented: $showSettings) {
                NavigationView {
                    SettingsHome(profileData: $profileData)
                        .navigationBarItems(trailing: Button("Done") {
                            showSettings = false

                            profile.update(from: profileData)
                            do { try viewContext.save() } catch {
                                print(error.localizedDescription)
                            }
                            PersistenceController.shared.save()                            
                        })
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle("Settings")
                }
                .environment(\.colorScheme, profile.theme == Themes.system.id ? colorScheme :
                                            profile.theme == Themes.light.id ? .light : .dark)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
