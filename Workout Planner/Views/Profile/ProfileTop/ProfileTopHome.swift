//
//  ProfileTopHome.swift
//  Workout Planner
//
//  The top of the profile view showing simple user details.
//

import SwiftUI
import HealthKit
import Charts

struct ProfileTopHome: View {

    @ObservedObject var profile: Profile

    var workoutHistories: [WorkoutHistory]

    var body: some View {
        VStack(spacing: 0) {
            TwelveWeekGraph(workoutHistories: workoutHistories)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
            Text("Past 12 Weeks - Workout Minutes")
                .fontWeight(.semibold)
        }
        .padding([.leading, .trailing])
    }
}
