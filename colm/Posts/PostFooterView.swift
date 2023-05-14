//
//  PostFooterView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 26/04/2023.
//

import SwiftUI

struct PostFooterView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var post: Post

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: post.likedByProfile ? "heart.fill" : "heart")
                .foregroundColor(post.likedByProfile ? .red : .gray)
                .onTapGesture {
                    togglePostReaction()
                }
            
            Spacer()
            
            if let postedAtMillis = post.createdAtMilliseconds {
                ElapsedTimeView(elapsedTimeMilliseconds: postedAtMillis).font(.footnote)
            }
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

struct PostFooterView_Previews: PreviewProvider {
    static var previews: some View {
        PostFooterView(post: Post.mock)
            .previewLayout(PreviewLayout.sizeThatFits)
            .environmentObject(UserProfile.mockUser())
    }
}
