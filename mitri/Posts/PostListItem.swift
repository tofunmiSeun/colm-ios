//
//  PostListItem.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 03/12/2022.
//

import SwiftUI

extension RelativeDateTimeFormatter {
    func withDateTimeStyle(dateTimeStyle: RelativeDateTimeFormatter.DateTimeStyle) -> RelativeDateTimeFormatter {
        self.dateTimeStyle = dateTimeStyle
        return self
    }
}

struct PostListItem: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var post: Post
    var onPostDeletion: () -> Void
    
    private let formatter = RelativeDateTimeFormatter()
        .withDateTimeStyle(dateTimeStyle: .named)
    
    private var headerLayout: some View {
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
                    .buttonStyle(.plain)
                }
            } label: {
                Label("Actions", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var mainSectionLayout: some View {
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
    
    private var footerLayout: some View {
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
    
    var body: some View {
        NavigationLink {
            PostDetailsView(post: post)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                headerLayout
                mainSectionLayout
                footerLayout
                Divider()
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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
            .padding(.top, 8)
            .previewLayout(PreviewLayout.sizeThatFits)
            .environmentObject(UserProfile.mockUser())
    }
}
