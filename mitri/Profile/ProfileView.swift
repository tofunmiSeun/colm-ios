//
//  ProfileView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    let profileId: String
    
    @State var profileOverview: ProfileOverview?
    @State private var postsByProfile = [Post]()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let overview = profileOverview {
                    VStack(spacing: 16) {
                        ProfileOverviewSection(profileOverview: overview, onFollowershipToggled: fetchProfileOverview)
                        
                        Divider()
                        
                        ForEach(postsByProfile) { post in
                            PostListItem(post: post, onPostDeletion: fetchPostsByProfile)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(profileOverview?.username ?? "")")
            .task {
                fetchProfileOverview()
                fetchPostsByProfile()
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileId: "mock_profile", profileOverview: ProfileOverview.mock)
            .environmentObject(UserProfile.mockUser())
    }
}
