import SwiftUI

struct DiscoverView: View {
    enum DiscoverViewTab: String {
        case topPosts;
        case people;
        
        var labelText: String {
            switch self {
            case .topPosts:
                return "Top posts"
            case .people:
                return "People"
            }
        }
    }
    private var tabs: [DiscoverViewTab] {
        [.topPosts, .people]
    }
    
    @EnvironmentObject var loggedInUser: UserProfile
    @State var posts = [Post]()
    @State var profiles = [Profile]()
    
    @State private var selectedTab: DiscoverViewTab = .topPosts
    @State private var searchKey = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 20) {
                    ForEach(tabs, id: \.self) { tab in
                        Text("\(tab.labelText)")
                            .onTapGesture {
                                withAnimation {
                                    selectedTab = tab
                                }
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)
                            .foregroundColor(textColorForTabLabel(tab))
                            .overlay(alignment: .bottom) {
                                if selectedTab == tab {
                                    Rectangle()
                                        .foregroundColor(.accentColor)
                                        .frame(height: 3)
                                        .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .overlay(alignment: .bottom) {
                    Divider()
                }
                .padding(.horizontal, 8)
                TabView(selection: $selectedTab)  {
                    ScrollView(showsIndicators: false) {
                        RowsOfPosts(posts: posts, onPostDeletion: fetchPosts)
                    }
                    .tag(DiscoverViewTab.topPosts)
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading) {
                            ForEach(profiles) { profile in
                                NavigationLink {
                                    ProfileView(profileId: profile.id)
                                } label: {
                                    VStack(alignment: .leading) {
                                        ProfileListItem(username: profile.username, name: profile.name)
                                        Divider()
                                    }.contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }.padding(.horizontal, 8)
                    }
                    .tag(DiscoverViewTab.people)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .searchable(text: $searchKey)
            .onChange(of: searchKey) { _ in
                fetchPosts()
                fetchProfiles()
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
        let uri = searchKey.isEmpty ? "/discover/top-posts?profileId=\(loggedInUser.profileId)" :
        "/post/search?searchKey=\(searchKey)&profileId=\(loggedInUser.profileId)"
        
        Api.get(uri: uri) { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    posts = response
                }
            }
        }
    }
    
    func fetchProfiles() {
        let uri = searchKey.isEmpty ? "/discover/top-active-profiles?profileId=\(loggedInUser.profileId)" :
        "/profile/search/username?key=\(searchKey)"
        
        Api.get(uri: uri) { data in
            DispatchQueue.main.async {
                if let response: [Profile] = Api.Utils.decodeAsObject(data: data) {
                    profiles = response
                }
            }
        }
    }
    
    func textColorForTabLabel(_ tabForLabel: DiscoverViewTab) -> Color {
        return tabForLabel == selectedTab ? .accentColor : .primary.opacity(0.9)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(posts: [Post.mock], profiles: [Profile.mock])
            .environmentObject(UserProfile.mockUser())
    }
}
