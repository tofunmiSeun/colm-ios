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
    var onPostDeletion: () -> Void
    
    var postContentLayout: some View {
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
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                NavigationLink {
                    ProfileView(profileId: post.author)
                } label: {
                    Text("\(post.authorUsername)")
                        .styleAsUsername()
                }.buttonStyle(.plain)
                
                Spacer()
                
                Menu {
                    if post.author == loggedInUser.profileId {
                        Button(role: .destructive) {
                            deletePost()
                        } label: {
                            Label("Delete", systemImage: "trash.circle")
                                .foregroundColor(.red)
                        }
                    }
                } label: {
                    Label("Actions", systemImage: "ellipsis")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.gray)
                }
            }
            
            NavigationLink {
                PostDetailsView(post: post)
            } label: {
                postContentLayout
            }.buttonStyle(.plain)
            
            HStack(spacing: 12) {
                Image(systemName: post.likedByProfile ? "heart.fill" : "heart")
                    .foregroundColor(post.likedByProfile ? .red : .gray)
                    .onTapGesture {
                        togglePostReaction()
                    }
            }.padding(.top, 10)
            
            Divider().padding(.bottom, 16)
        }
    }
    
    func deletePost() {
        let uri = "/post/\(post.id)?profileId=\(loggedInUser.profileId)"
        Api.delete(uri: uri) { data in
            DispatchQueue.main.async {
                onPostDeletion()
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

struct PostListItem_Previews: PreviewProvider {
    static var previews: some View {
        PostListItem(post: Post.mockWithMediaContent, onPostDeletion: {return})
            .previewLayout(PreviewLayout.sizeThatFits)
            .environmentObject(UserProfile.mockUser())
    }
}
