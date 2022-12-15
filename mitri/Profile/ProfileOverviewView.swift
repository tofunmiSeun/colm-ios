//
//  ProfileOverviewView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct ProfileOverviewView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    
    let profileOverview: ProfileOverview
    let onFollowershipToggled: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                
                VStack(alignment: .leading) {
                    Text("\(profileOverview.username)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if profileOverview.name != nil {
                        Text(profileOverview.name!)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    
                    if profileOverview.id != loggedInUser.profileId {
                        Button {
                            toggleUserFollowership()
                        } label: {
                            Text(profileOverview.requesterFollowsProfile ? "Unfollow": "Follow")
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.caption2)
                    }
                    
                }
            }.frame(alignment: .leading)
            
            if profileOverview.description != nil {
                Text(profileOverview.description!)
                    .fontWeight(.thin)
            }
            
            HStack(spacing: 12) {
                ProfileStatView(label: "posts", value: "\(profileOverview.postCount)")
                //ProfileStatView(label: "likes", value: "\(profileOverview.likesCount)")
                ProfileStatView(label: "follows", value: "\(profileOverview.followersCount)")
                ProfileStatView(label: "followed", value: "\(profileOverview.followingCount)")
                Spacer()
            }
            
            Spacer()
            
        }
    }
    
    func toggleUserFollowership() {
        let action = profileOverview.requesterFollowsProfile ? "unfollow" : "follow"
        Api.post(uri: "/profile/\(profileOverview.id)/\(action)?profileId=\(loggedInUser.profileId)") { data in
            onFollowershipToggled()
        }
    }
    
}

struct ProfileOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileOverviewView(profileOverview: ProfileOverview.mock, onFollowershipToggled: {return})
            .environmentObject(UserProfile.mockUser())
    }
}
