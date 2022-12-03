//
//  PostListItem.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 03/12/2022.
//

import SwiftUI

struct PostListItem: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(post.authorUsername)")
                .fontWeight(.semibold)
            Text("\(post.content)")
                .fontWeight(.thin)
            HStack(spacing: 8) {
                Button {
                    togglePostReaction()
                } label: {
                    Image(systemName: post.likedByProfile ? "hand.thumbsup.fill" : "hand.thumbsup")
                }.buttonStyle(.borderless)
            }.padding(.top, 10)
        }
    }
    
    func togglePostReaction() {
        let uri = post.likedByProfile ? "/post/\(post.id)/like/remove" : "/post/\(post.id)/like"
        Api.post(uri: "\(uri)?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                post.likedByProfile.toggle()
            }
        }
    }
}

struct PostListItem_Previews: PreviewProvider {
    static var previews: some View {
        PostListItem(post: Post.mock)
            .frame(width: .infinity, height: 100)
            .environmentObject(UserProfile.mockUser())
    }
}
