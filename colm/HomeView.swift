import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State private var posts: [Post] = [Post.mock]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    RowsOfPosts(posts: posts, onPostDeletion: fetchPosts)
                }
                .refreshable {
                    fetchPosts()
                }
                
                NavigationLink(destination: CreatePostView()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .fontWeight(.thin)
                        .shadow(radius: 2)
                }
                .padding([.bottom], 16)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchPosts()
            }
        }
    }
    
    func fetchPosts() {
        Api.get(uri: "/post/feed?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    posts = response
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserProfile.mockUser())
    }
}
