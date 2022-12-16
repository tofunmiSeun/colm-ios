//
//  LoggedInUserView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import SwiftUI

struct LoggedInUserView: View {
    var body: some View {
        TabView {
            HomeView()
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            DiscoverView()
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }
            NotificationsView()
            .tabItem {
                Label("Notifications", systemImage: "bell")
            }
            ProfileView(profileId: UserProfile.currentLoggedInUser().profileId)
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
        .environmentObject(UserProfile.currentLoggedInUser())
    }
}

struct LoggedInUserView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInUserView()
    }
}
