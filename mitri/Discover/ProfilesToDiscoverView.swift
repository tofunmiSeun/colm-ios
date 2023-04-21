import SwiftUI

struct Profile: Identifiable, Codable, Hashable {
    var id: String;
    var username: String;
    var name: String?;
    var description: String?;
    
    static var mock = Profile(id: "profile123", username: "tofunmi_og",
                              name: "Tofunmi", description: "Founder @mitri")
    
    static var mock_2 = Profile(id: "profile_xts", username: "bot_man",
                              name: "Botty", description: "Bot that yaps")
}

struct ProfilesToDiscoverView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var profiles = [Profile]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(profiles) { profile in
                    NavigationLink {
                        ProfileView(profileId: profile.id)
                    } label: {
                        ProfileListItem(username: profile.username, name: profile.name)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .refreshable {
            fetchProfiles()
        }
        .onAppear {
            fetchProfiles()
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

struct ProfilesToDiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesToDiscoverView(profiles: [Profile.mock])
            .environmentObject(UserProfile.mockUser())
    }
}
