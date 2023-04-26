import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var posts = [Post]()
    @State var profiles = [Profile]()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                Section(header: Text("Follows")) {
                    ForEach(profiles) { profile in
                        NavigationLink {
                            ProfileView(profileId: profile.id)
                        } label: {
                            ProfileListItem(username: profile.username, name: profile.name)
                        }
                        .buttonStyle(.plain)
                    }
                }
                Divider().padding(.vertical, 16)
                Section(header: Text("Trending")) {
                    RowsOfPosts(posts: posts, onPostDeletion: fetchPosts)
                    RowsOfPosts(posts: posts, onPostDeletion: fetchPosts)
                }
            }
            .refreshable {
                fetchPosts()
                fetchProfiles()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Discover")
            .onAppear {
                fetchPosts()
                fetchProfiles()
            }
        }
    }
    
    func fetchPosts() {
        Api.get(uri: "/discover/top-posts?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    posts = response
                }
            }
        }
    }
    
    func fetchProfiles() {
        Api.get(uri: "/discover/top-active-profiles?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Profile] = Api.Utils.decodeAsObject(data: data) {
                    profiles = response
                }
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(posts: [Post.mock], profiles: [Profile.mock])
            .environmentObject(UserProfile.mockUser())
    }
}
