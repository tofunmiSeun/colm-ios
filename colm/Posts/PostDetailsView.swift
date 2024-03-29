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
                    VStack(alignment: .leading) {
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
                        
                        PostFooterView(post: post).padding(.top, 8)
                    
                    }.padding(8)
                    
                    Divider().padding(.top, 4).padding(.bottom, 8)
                    
                    if replies.count > 0 {
                        HStack {
                            Text("Replies")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(8)
                            Spacer()
                        }
                        .overlay(alignment: .bottom) {
                            Divider().padding(.horizontal, 8)
                        }
                        RowsOfPosts(posts: replies, onPostDeletion: fetchReplies)
                            .padding(.top, 8)
                    }
                    
                }
            }
            
            PostReplyView(postId: post.id, profileId: loggedInUser.profileId, refreshReplies: fetchReplies)
                .padding()
                .cornerRadius(4)
                .background(.gray.opacity(0.1))
        }
        .refreshable {
            fetchReplies()
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
