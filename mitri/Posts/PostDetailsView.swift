//
//  PostDetailsView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 09/12/2022.
//

import SwiftUI

struct PostDetailsView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @FocusState private var isUsernameFocused: Bool
    let post: Post
    
    @State private var replies = [Post]()
    @State private var reply = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if let postText = post.content {
                        Text("\(postText)")
                            .styleAsPostText()
                    }
                    
                    if let mediaContents = post.mediaContents {
                        if mediaContents.count > 0 {
                            VStack {
                                TabView {
                                    ForEach(mediaContents) { content in
                                        MediaContentView(mediaContent: content)
                                    }
                                }
                                .styleAsMediaContentCarousel()
                            }.padding(.vertical, 16)
                        }
                    }
                    
                    if replies.count > 0 {
                        Text("Replies")
                            .font(.title)
                            .padding(.vertical, 8)
                        RowsOfPosts(posts: replies, onPostDeletion: fetchReplies)
                            .padding(.horizontal, -16)
                    }
                    
                }.padding()
            }
            
            VStack {
                Divider()
                PostReplyView(postId: post.id, profileId: loggedInUser.profileId, refreshReplies: fetchReplies)
            }.padding()
        }
        .navigationTitle(post.authorUsername)
        .onAppear {
            fetchReplies()
        }
    }
    
    func fetchReplies() {
        let uri = "/post/\(post.id)/replies?profileId=\(loggedInUser.profileId)"
        Api.get(uri: uri) { data in
            if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                DispatchQueue.main.async {
                    replies = response
                }
            }
        }
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsView(post: Post.mockWithMediaContent)
            .environmentObject(UserProfile.mockUser())
    }
}
