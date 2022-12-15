//
//  PostsToDiscoverView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct PostsToDiscoverView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var posts = [Post]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            RowsOfPosts(posts: posts, onPostDeletion: fetchPosts)
        }
        .refreshable {
            fetchPosts()
        }
        .onAppear {
            fetchPosts()
        }
    }
    
    func fetchPosts() {
        Api.get(uri: "/discover/top-posts?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    posts = response
                }
            }
        }
    }
}

struct PostsToDiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        PostsToDiscoverView(posts: [Post.mock]).environmentObject(UserProfile.mockUser())
    }
}
