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
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(post.authorUsername)")
                    .styleAsUsername()
                    .font(.title)
                
                Text("\(post.content)")
                    .styleAsPostText()
            }.padding(.bottom, 12)
            
            Divider()
            
            List {
                ForEach(replies) { post in
                    PostListItem(post: post)
                }
            }
            .listStyle(.plain)
            .onAppear {
                getReplies()
            }
            
            Spacer()
            Divider()
            HStack {
                TextField(text: $reply, prompt: Text("Reply post").promptText()) {
                    Text("Text")
                }
                .autocorrectionDisabled()
                Spacer()
                Button {
                    replyToPost()
                } label: {
                    Text("Send")
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                .font(.subheadline)
                .disabled(reply.count == 0)
            }
            .padding(8)
        }.padding()
    }
    
    func getReplies() {
        let uri = "/post/\(post.id)/replies?profileId=\(loggedInUser.profileId)"
        Api.get(uri: uri) { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    replies = response
                }
            }
        }
    }
    
    func replyToPost() {
        let uri = "/post/\(post.id)/reply?profileId=\(loggedInUser.profileId)"
        Api.post(uri: uri, body: ["content": reply]) { _ in
            DispatchQueue.main.async {
                reply = ""
                print("Successful")
                getReplies()
            }
        }
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsView(post: Post.mock)
    }
}
