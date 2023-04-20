import SwiftUI

struct LoggedInUserView: View {
    var body: some View {
        NavigationStack {
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
                ChatsView()
                    .tabItem {
                        Label("Chats", systemImage: "message")
                    }
                ProfileView(profileId: UserProfile.currentLoggedInUser().profileId)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
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
