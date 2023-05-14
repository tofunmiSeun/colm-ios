import SwiftUI

struct LoggedInUserView: View {
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .labelStyle(.iconOnly)
                    }
                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "magnifyingglass")
                            .labelStyle(.iconOnly)
                    }
                NotificationsView()
                    .tabItem {
                        Label("Notifications", systemImage: "bell")
                            .labelStyle(.iconOnly)
                    }
                ChatsView(navPath: $navPath)
                    .tabItem {
                        Label("Chats", systemImage: "message")
                            .labelStyle(.iconOnly)
                    }
                NavigationView {
                    ProfileView(profileId: UserProfile.currentLoggedInUser().profileId)
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                        .labelStyle(.iconOnly)
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
