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
                .styleAsUsername()
            
            Text("\(post.content)")
                .styleAsPostText()
            
            if let mediaContents = post.mediaContents {
                VStack {
                    TabView {
                        ForEach(mediaContents) { content in
                            MediaContentView(mediaContent: content)
                        }
                    }
                    .styleAsMediaContentCarousel()
                }.padding(.vertical, 16)
            }
            
            HStack(spacing: 12) {
                
                Image(systemName: post.likedByProfile ? "heart.fill" : "heart")
                    .foregroundColor(post.likedByProfile ? .red : .gray)
                    .onTapGesture {
                        togglePostReaction()
                    }
                
                NavigationLink(destination: PostDetailsView(post: post)) {
                    Image(systemName: "message")
                        .foregroundColor(.gray)
                }
                
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
        NavigationStack {
            PostListItem(post: Post.mockWithMediaContent)
                .frame(width: .infinity, height: 500)
                .environmentObject(UserProfile.mockUser())
        }
    }
}
