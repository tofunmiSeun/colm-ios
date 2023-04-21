import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @EnvironmentObject var loggedInUserState: LoggedInUserState
    let profileId: String
    
    @State var profileOverview: ProfileOverview?
    @State private var postsByProfile = [Post]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if let overview = profileOverview {
                VStack(spacing: 16) {
                    ProfileOverviewSection(profileOverview: overview, onFollowershipToggled: fetchProfileOverview)
                        .padding()
                    Divider()
                    RowsOfPosts(posts: postsByProfile, onPostDeletion: fetchPostsByProfile)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(profileOverview?.username ?? "")")
        .refreshable {
            fetchProfileOverview()
            fetchPostsByProfile()
        }
        .task {
            fetchProfileOverview()
            fetchPostsByProfile()
        }.toolbar {
            if profileOverview?.id ?? "" == loggedInUser.profileId {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            logUserout()
                        } label: {
                            Text("Logout")
                        }
                    } label: {
                        Label("Actions", systemImage: "ellipsis")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        
    }
    
    func fetchProfileOverview() {
        Api.get(uri: "/profile/\(profileId)/overview?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: ProfileOverview = Api.Utils.decodeAsObject(data: data) {
                    profileOverview = response
                }
            }
        }
    }
    
    func fetchPostsByProfile() {
        Api.get(uri: "/post/by-profile/\(profileId)?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    postsByProfile = response
                }
            }
        }
    }
    
    func logUserout() {
        Api.post(uri: "/user/logout") { _ in
            loggedInUserState.clearSavedUserProfile()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileId: "mock_profile", profileOverview: ProfileOverview.mock)
            .environmentObject(UserProfile.mockUser())
    }
}
