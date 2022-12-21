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

extension Date {
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
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
                }
            } label: {
                Label("Actions", systemImage: "ellipsis")
                    .labelStyle(.iconOnly)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var mainSectionLayout: some View {
        VStack(alignment: .leading) {
            if let postText = post.content {
                Text("\(postText)")
                    .styleAsPostText()
                    .padding(.horizontal, 16)
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
                        .padding(.horizontal, 16)
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
                let postedAtDate = Date(milliseconds: postedAtMillis)
                TimelineView(.animation(minimumInterval: 5)) { timeline in
                    let formatted = formatter.localizedString(for: postedAtDate, relativeTo: timeline.date)
                    Text("\(formatted)")
                        .fontWeight(.ultraLight)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerLayout
            
            NavigationLink {
                PostDetailsView(post: post)
            } label: {
                mainSectionLayout
            }.buttonStyle(.plain)
            
            footerLayout
            
            Divider()
        }.padding(.bottom, 8)
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
