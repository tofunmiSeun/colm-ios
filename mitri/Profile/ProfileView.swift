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
    
    var body: some View {
        VStack {
            if let overview = profileOverview {
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                        
                        VStack(alignment: .leading) {
                            Text("\(overview.username)")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            if overview.name != nil {
                                Text(overview.name!)
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            
                            if profileId != loggedInUser.profileId {
                                Button {
                                    Task {
                                        await toggleUserFollowership()
                                    }
                                } label: {
                                    Text(overview.requesterFollowsProfile ? "Unfollow": "Follow")
                                }
                                .buttonStyle(.borderedProminent)
                                .font(.caption2)
                            }
                            
                        }
                    }.frame(alignment: .leading)
                    
                    if overview.description != nil {
                        Text(overview.description!)
                            .fontWeight(.thin)
                    }
                    
                    
                    HStack(spacing: 12) {
                        ProfileStatView(label: "posts", value: "\(overview.postCount)")
                        //ProfileStatView(label: "likes", value: "\(overview.likesCount)")
                        ProfileStatView(label: "follows", value: "\(overview.followersCount)")
                        ProfileStatView(label: "followed", value: "\(overview.followingCount)")
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .task {
            Task {
                await fetchProfileOverview();
            }
        }
    }
    
    func toggleUserFollowership() async {
        guard let overview = profileOverview else {
            return
        }
        
        var action = overview.requesterFollowsProfile ? "unfollow" : "follow"
        Api.post(uri: "/profile/\(profileId)/\(action)?profileId=\(loggedInUser.profileId)") { data in
            Task {
                await fetchProfileOverview()
            }
        }
    }
    
    func fetchProfileOverview() async {
        Api.get(uri: "/profile/\(profileId)/overview?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: ProfileOverview = Api.Utils.decodeAsObject(data: data) {
                    profileOverview = response
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileId: "mock_profile", profileOverview: ProfileOverview.mock).environmentObject(UserProfile.mockUser())
    }
}
