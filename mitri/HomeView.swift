//
//  HomeView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State private var posts: [Post] = [Post.mock]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(posts) { post in
                        PostListItem(post: post, onPostDeletion: fetchPosts)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    fetchPosts()
                }
                
                NavigationLink(destination: CreatePostView()) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .fontWeight(.thin)
                        .shadow(radius: 2)
                }
                .padding([.bottom], 16)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchPosts()
            }
        }
    }
    
    func fetchPosts() {
        Api.get(uri: "/post?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Post] = Api.Utils.decodeAsObject(data: data) {
                    posts = response
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserProfile.mockUser())
    }
}
